#!/usr/bin/env bash

# =============================================================================
# PATH MAP
# Add your project aliases here. One line per project.
# Usage: c<alias>, e<alias>, cd<alias>
# Example: cfol, efol, cdfol
# =============================================================================

declare -A PATH_MAP

# Sites
PATH_MAP[fol]="$BASE/sites/fol"
PATH_MAP[nk]="$BASE/sites/naykel"
PATH_MAP[zcc]="$BASE/sites/zcc"

# Packages
PATH_MAP[authit]="$BASE/nk_packages/authit"
PATH_MAP[devit]="$BASE/nk_packages/devit"

# Scriptit
PATH_MAP[scriptit]="$HOME/scriptit"

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
    eval "function c${alias}() { code \"${path}\"; }"

    # Explorer shortcut (works in both WSL and Linux)
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
