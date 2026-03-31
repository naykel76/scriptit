# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## What this repo is

A collection of Bash aliases and shell functions for Git Bash and WSL on
Windows. It loads automatically via `~/.bashrc → init.sh → config/*.sh +
aliases/*.sh`.

## Environment requirements

- `$BASE` must be exported in `~/.bashrc` **before** sourcing `init.sh`
  - Git Bash: `export BASE="/c/Users/YOUR_USERNAME"`
  - WSL: `export BASE="/mnt/c/Users/YOUR_USERNAME"`
- A `.env` file must exist at `~/scriptit/.env` (copy from `.env.example` and
  fill in `SSH_USER`, `SERVER_IP`, `LOCAL_BACKUP_DIR`)

## Directory layout

| Path                          | Purpose                                                                                     |
| ----------------------------- | ------------------------------------------------------------------------------------------- |
| `init.sh`                     | Entry point — loads `.env`, then all `config/*.sh` and `aliases/*.sh`                       |
| `config/paths.sh`             | Defines `PATH_MAP` and auto-generates `c<key>`, `e<key>`, `cd<key>` functions               |
| `config/forge.sh`             | Exports SSH/server variables (`$SERVER`, `$SITE_PATH`, etc.)                                |
| `aliases/git.sh`              | Git shortcuts (`ga`, `gc`, `gco`, `gp`, `gpu`, `gpa`, `gr`, `gt`, …)                        |
| `aliases/laravel.sh`          | Artisan (`pa`, `pam`, `pamfs`), Livewire (`lc`, `lca`, `lcu`), Pest (`pt`, `ptf`, `ptb`, …) |
| `aliases/npm.sh`              | NPM shortcuts (`nrd`, `nrb`, `nr`)                                                          |
| `aliases/misc.sh`             | Project launchers that `cd` + open VS Code + run `opencode`                                 |
| `scripts/backup-db.sh`        | Interactive: SSH to Forge server, `mysqldump`, `scp` back, clean up                         |
| `scripts/fix-line-endings.sh` | Converts CRLF → LF for all `.sh` and `.env` files                                           |

## Adding things

**New project shortcut** — add an entry to `PATH_MAP` in `config/paths.sh`:

```bash
PATH_MAP[myproject]="$BASE/sites/myproject"
```

This auto-creates `cmyproject` (VS Code), `emyproject` (Explorer), `cdmyproject`
(cd).

**New aliases** — create a new `.sh` file in `aliases/` or `config/`; it is
auto-sourced on the next shell start.

## Reloading

```bash
source ~/.bashrc   # or the alias: reload
```

## Line ending issues

If scripts fail with `command not found` or `unexpected end of file`, run:

```bash
bash ~/scriptit/scripts/fix-line-endings.sh
```

## Known issues (tracked in nk_tasks.md)

- `init.sh` hardcodes `SCRIPTIT_DIR="$HOME/scriptit"` — in WSL this resolves to
  `/home/<user>/scriptit`, not the Windows path under `/mnt/c/`. If scripts fail
  to load in WSL, set `SCRIPTIT_DIR` manually before sourcing.
- `backup-db.sh` references credential variables — verify they match what is
  defined in your `.env` before running.
- The `scriptit()` shortcut in `aliases/misc.sh` depends on
  `cdscriptit`/`cscriptit` being generated from `config/paths.sh`; ensure
  `PATH_MAP[scriptit]` is present and correctly keyed.
