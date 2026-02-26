#!/usr/bin/env bash

# =============================================================================
# PATH MAP
# Add your project aliases here. One line per project.
# Usage: c<alias>, e<alias>, cd<alias>
# Example: cfol, efol, cdfol
# =============================================================================

declare -A PATH_MAP

# Sites
PATH_MAP[backups]="$BASE/sites/backups"
PATH_MAP[fol]="$BASE/sites/fol"
PATH_MAP[fold]="$BASE/sites/factsoflife"
PATH_MAP[gotime]="$BASE/sites/gotime"
PATH_MAP[jtb]="$BASE/sites/nk_jtb"
PATH_MAP[nbw]="$BASE/sites/nbw"
PATH_MAP[nk]="$BASE/sites/naykel"
PATH_MAP[sites]="$BASE/sites"
PATH_MAP[zcc]="$BASE/sites/zcc"

# Packages
PATH_MAP[authit]="$BASE/sites/nk_packages/authit"
PATH_MAP[contactit]="$BASE/sites/nk_packages/contactit"
PATH_MAP[devit]="$BASE/sites/nk_packages/devit"
PATH_MAP[gt]="$BASE/sites/nk_packages/gotime"
PATH_MAP[postit]="$BASE/sites/nk_packages/postit"

# Scriptit
PATH_MAP[scriptit]="$BASE/scriptit"

# =============================================================================
# AUTO-GENERATE COMMANDS FROM PATH_MAP
# For each alias you get:
#   c<alias>   →  open in VS Code  (e.g. cfol)
#   e<alias>   →  open in Explorer (e.g. efol)
#   cd<alias>  →  cd to directory  (e.g. cdfol)
# =============================================================================

for alias in "${!PATH_MAP[@]}"; do
    path="${PATH_MAP[$alias]}"

    # VS Code shortcut
    eval "function c${alias}() {
        if command -v explorer.exe &>/dev/null; then
            code \"\$(wslpath -w '${path}')\"
        else
            code \"${path}\"
        fi
    }"

    # Explorer shortcut (works in both WSL and Git Bash)
    eval "function e${alias}() {
        if command -v explorer.exe &>/dev/null; then
            explorer.exe \"\$(wslpath -w '${path}')\"
        else
            xdg-open \"${path}\"
        fi
    }"

    # cd shortcut
    eval "function cd${alias}() { cd \"${path}\"; }"
done