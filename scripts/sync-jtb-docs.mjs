#!/usr/bin/env node

import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { createHash } from 'node:crypto';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const scriptitDir = path.resolve(__dirname, '..');
const dataDir = path.join(scriptitDir, '.data', 'jtb-docs-sync');

const defaults = {
    source: process.env.JTB_DOCS_SOURCE || path.join(os.homedir(), 'sites', 'nk_jtb', 'docs'),
    target: process.env.JTB_DOCS_TARGET || path.join(os.homedir(), 'sites', 'naykel', 'resources', 'views', 'docs', 'jtb'),
    logFile: process.env.JTB_DOCS_SYNC_LOG || path.join(dataDir, 'sync.log'),
    stateFile: process.env.JTB_DOCS_SYNC_STATE || path.join(dataDir, 'sync-state.json'),
    conflictDir: process.env.JTB_DOCS_SYNC_CONFLICTS || path.join(dataDir, 'conflicts'),
};

const stats = {
    conflicts: 0,
    syncedAtoB: 0,
    syncedBtoA: 0,
    newToA: 0,
    newToB: 0,
    deletedFromA: 0,
    deletedFromB: 0,
    errors: 0,
};

const options = parseArgs(process.argv.slice(2));

if (options.help) {
    printHelp();
    process.exit(0);
}

ensureDir(path.dirname(defaults.logFile));
ensureDir(defaults.conflictDir);
rotateLog(defaults.logFile);

log(`=== Starting JTB docs sync: source=${defaults.source}, target=${defaults.target}, dryRun=${options.dryRun}, delete=${options.deleteMissing} ===`, true);

try {
    syncFolders(defaults.source, defaults.target, options);
} catch (error) {
    stats.errors += 1;
    log(`ERROR: ${error.message}`, true);
    process.exitCode = 1;
}

log('', true);
log('=== SUMMARY ===', true);
log(`Conflicts found: ${stats.conflicts}`, true);
log(`Synced source -> target: ${stats.syncedAtoB}`, true);
log(`Synced target -> source: ${stats.syncedBtoA}`, true);
log(`New files to source: ${stats.newToA}`, true);
log(`New files to target: ${stats.newToB}`, true);
log(`Deleted from source: ${stats.deletedFromA}`, true);
log(`Deleted from target: ${stats.deletedFromB}`, true);
log(`Errors: ${stats.errors}`, true);
log('=== Sync complete ===', true);

console.log(`\nJTB docs sync complete. Dry-run: ${options.dryRun}. See log at ${defaults.logFile}`);

function parseArgs(args) {
    const parsed = {
        dryRun: false,
        deleteMissing: false,
        verbose: false,
        help: false,
    };

    for (const arg of args) {
        switch (arg) {
            case '--dry-run':
            case '-n':
                parsed.dryRun = true;
                break;
            case '--delete':
                parsed.deleteMissing = true;
                break;
            case '--verbose':
            case '-v':
                parsed.verbose = true;
                break;
            case '--help':
            case '-h':
                parsed.help = true;
                break;
            default:
                throw new Error(`Unknown option: ${arg}. Use --help for usage.`);
        }
    }

    return parsed;
}

function printHelp() {
    console.log(`JTB docs sync\n\nUsage:\n  sync-jtb-docs [--dry-run] [--delete] [--verbose]\n\nOptions:\n  --dry-run, -n   Preview actions without writing changes\n  --delete        Propagate deletions based on previous sync state\n  --verbose, -v   Print all actions while syncing\n  --help, -h      Show this help\n\nFirst run:\n  If no sync state exists yet, overlapping files bootstrap from nk_jtb/docs into\n  the Laravel docs copy. Files that exist only on one side are copied across.\n`);
}

function syncFolders(pathA, pathB, runtimeOptions) {
    if (!fs.existsSync(pathA)) {
        throw new Error(`Source path not found: ${pathA}`);
    }

    if (!fs.existsSync(pathB)) {
        throw new Error(`Target path not found: ${pathB}`);
    }

    const hasState = fs.existsSync(defaults.stateFile);
    const state = loadState(defaults.stateFile);

    if (!hasState) {
        log('No prior sync state found. Bootstrapping with source authoritative for overlapping files.', true);
    }

    const lookupA = collectFiles(pathA);
    const lookupB = collectFiles(pathB);
    const allKeys = [...new Set([...lookupA.keys(), ...lookupB.keys()])].sort();
    const newState = {};

    for (const rel of allKeys) {
        const fileA = lookupA.get(rel);
        const fileB = lookupB.get(rel);
        const destA = path.join(pathA, rel);
        const destB = path.join(pathB, rel);
        const hashA = fileA ? hashFile(fileA) : null;
        const hashB = fileB ? hashFile(fileB) : null;
        const prev = state[rel] || null;
        const prevA = prev ? prev.A : null;
        const prevB = prev ? prev.B : null;

        if (fileA && fileB) {
            if (!hasState) {
                if (hashA !== hashB) {
                    stats.syncedAtoB += 1;
                    if (runtimeOptions.dryRun) {
                        log(`[DRY-RUN] Would bootstrap target from source: ${rel}`);
                    } else {
                        copyFile(fileA, destB);
                        log(`Bootstrapped target from source: ${rel}`);
                    }
                }
                newState[rel] = { A: hashA, B: hashA };
                continue;
            }

            const aChanged = hashA !== prevA;
            const bChanged = hashB !== prevB;

            if (aChanged && bChanged) {
                stats.conflicts += 1;
                const conflictDir = buildConflictDir(rel);
                log(`[CONFLICT] Both modified: ${rel}`, true);
                log(`Saved to: ${conflictDir}`, true);

                if (!runtimeOptions.dryRun) {
                    ensureDir(conflictDir);
                    const ext = path.extname(rel);
                    const base = path.basename(rel, ext);
                    copyFile(fileA, path.join(conflictDir, `${base}-source${ext}`));
                    copyFile(fileB, path.join(conflictDir, `${base}-target${ext}`));
                } else {
                    log('[DRY-RUN] Would save both versions to conflict folder', true);
                }

                newState[rel] = { A: hashA, B: hashB };
            } else if (aChanged) {
                stats.syncedAtoB += 1;
                if (runtimeOptions.dryRun) {
                    log(`[DRY-RUN] Would update target from source: ${rel}`);
                } else {
                    copyFile(fileA, destB);
                    log(`Updated target from source: ${rel}`);
                }
                newState[rel] = { A: hashA, B: hashA };
            } else if (bChanged) {
                stats.syncedBtoA += 1;
                if (runtimeOptions.dryRun) {
                    log(`[DRY-RUN] Would update source from target: ${rel}`);
                } else {
                    copyFile(fileB, destA);
                    log(`Updated source from target: ${rel}`);
                }
                newState[rel] = { A: hashB, B: hashB };
            } else {
                newState[rel] = { A: hashA, B: hashB };
            }

            continue;
        }

        if (fileA && !fileB) {
            if (!hasState || !prev) {
                stats.newToB += 1;
                if (runtimeOptions.dryRun) {
                    log(`[DRY-RUN] Would copy new file to target: ${rel}`);
                } else {
                    copyFile(fileA, destB);
                    log(`Copied new file to target: ${rel}`);
                }
                newState[rel] = { A: hashA, B: hashA };
            } else if (runtimeOptions.deleteMissing) {
                stats.deletedFromA += 1;
                log(`[DELETE] File deleted from target, deleting from source: ${rel}`, true);
                if (!runtimeOptions.dryRun) {
                    deleteFile(fileA);
                } else {
                    log('[DRY-RUN] Would delete from source', true);
                }
            } else {
                log(`[MISSING] File exists in source but missing in target: ${rel}`, true);
                newState[rel] = { A: hashA, B: null };
            }

            continue;
        }

        if (!fileA && fileB) {
            if (!hasState || !prev) {
                stats.newToA += 1;
                if (runtimeOptions.dryRun) {
                    log(`[DRY-RUN] Would copy new file to source: ${rel}`);
                } else {
                    copyFile(fileB, destA);
                    log(`Copied new file to source: ${rel}`);
                }
                newState[rel] = { A: hashB, B: hashB };
            } else if (runtimeOptions.deleteMissing) {
                stats.deletedFromB += 1;
                log(`[DELETE] File deleted from source, deleting from target: ${rel}`, true);
                if (!runtimeOptions.dryRun) {
                    deleteFile(fileB);
                } else {
                    log('[DRY-RUN] Would delete from target', true);
                }
            } else {
                log(`[MISSING] File exists in target but missing in source: ${rel}`, true);
                newState[rel] = { A: null, B: hashB };
            }
        }
    }

    if (!runtimeOptions.dryRun) {
        saveState(defaults.stateFile, newState);
    }
}

function collectFiles(rootDir) {
    const lookup = new Map();

    walk(rootDir, (filePath) => {
        const rel = path.relative(rootDir, filePath).split(path.sep).join('/');
        lookup.set(rel, filePath);
    });

    return lookup;
}

function walk(currentPath, onFile) {
    const entries = fs.readdirSync(currentPath, { withFileTypes: true });

    for (const entry of entries) {
        const fullPath = path.join(currentPath, entry.name);

        if (entry.isDirectory()) {
            walk(fullPath, onFile);
            continue;
        }

        if (entry.isFile()) {
            onFile(fullPath);
        }
    }
}

function hashFile(filePath) {
    return createHash('sha256').update(fs.readFileSync(filePath)).digest('hex');
}

function loadState(stateFile) {
    if (!fs.existsSync(stateFile)) {
        return {};
    }

    return JSON.parse(fs.readFileSync(stateFile, 'utf8'));
}

function saveState(stateFile, state) {
    ensureDir(path.dirname(stateFile));
    fs.writeFileSync(stateFile, JSON.stringify(state, null, 2));
}

function copyFile(source, destination) {
    ensureDir(path.dirname(destination));
    fs.copyFileSync(source, destination);
}

function deleteFile(filePath) {
    fs.rmSync(filePath, { force: true });
}

function ensureDir(dirPath) {
    fs.mkdirSync(dirPath, { recursive: true });
}

function rotateLog(logFile) {
    if (!fs.existsSync(logFile)) {
        return;
    }

    const size = fs.statSync(logFile).size;
    if (size <= 2 * 1024 * 1024) {
        return;
    }

    const timestamp = stamp(new Date(), true);
    const ext = path.extname(logFile);
    const base = logFile.slice(0, -ext.length);
    fs.renameSync(logFile, `${base}-${timestamp}${ext}`);
}

function buildConflictDir(rel) {
    const timestamp = stamp(new Date(), true);
    const safeName = rel.replace(/[\\/:*?"<>|]/g, '_');
    return path.join(defaults.conflictDir, `${timestamp}_${safeName}`);
}

function stamp(date, compact = false) {
    const pad = (value) => String(value).padStart(2, '0');
    const yyyy = date.getFullYear();
    const mm = pad(date.getMonth() + 1);
    const dd = pad(date.getDate());
    const hh = pad(date.getHours());
    const mi = pad(date.getMinutes());
    const ss = pad(date.getSeconds());

    return compact ? `${yyyy}${mm}${dd}-${hh}${mi}${ss}` : `${yyyy}-${mm}-${dd} ${hh}:${mi}:${ss}`;
}

function log(message, important = false) {
    const line = `${stamp(new Date())} - ${message}`;
    fs.appendFileSync(defaults.logFile, `${line}\n`);

    if (important || options.verbose) {
        console.log(line);
    }
}