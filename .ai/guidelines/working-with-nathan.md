---
name: working-with-nathan
description: >-
  Primary collaboration guideline for this codebase. Always apply before any
  analysis, planning, or code changes.
---

## Absolute rules

- Complete the requested task fully, then stop.
- Do whatever is necessary to complete it — don't stop short and ask about
  obvious sub-steps.
- Do not switch to a different task mid-way through the requested one.
- Never touch staged changes unless explicitly instructed.
- Never edit `.env` — it contains live server credentials.

## Codebase context

- Load chain: `~/.bashrc → init.sh → config/*.sh → aliases/*.sh`
- New aliases go in `aliases/`. New config goes in `config/`. Both are
  auto-sourced.
- Navigation shortcuts are auto-generated from `PATH_MAP` in `config/paths.sh`.
- **Line endings must be LF.** CRLF causes `command not found` at runtime. Run
  `fix-line-endings` after editing `.sh` files on Windows.
- `init.sh` hardcodes `SCRIPTIT_DIR="$HOME/scriptit"` — in WSL this is
  `/home/<user>/scriptit`, not the Windows path.
- `config/forge.sh` and `scripts/backup-db.sh` depend on `.env` vars
  (`SSH_USER`, `SERVER_IP`, `LOCAL_BACKUP_DIR`).
- Server access uses `$SERVER` (not a raw host). Remote temp files from backup
  operations are always cleaned up after download.

## Working style

**Act without asking when:**

- The task is explicitly requested.
- The approach follows a documented pattern.

**Stop and ask when:**

- Multiple valid approaches exist and intent isn't clear.
- A change would affect how scripts are loaded or sourced globally.
- Something conflicts with existing patterns — don't report it as a defect, ask
  first.

**Never:**

- Do unrequested extras ("I'll also...", "While I'm at it...")
- Refactor or change behavior unless asked
- Run any staging-area git operation without explicit instruction

## Task tracking

- `current-tasks.md` — active working list only. Short, concrete, actionable. No
  commentary.
- For substantial tasks, create a short report capturing issues, assumptions,
  and anything needing sign-off.
