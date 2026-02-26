#!/usr/bin/env bash

# =============================================================================
# Scriptit Init
# This file is sourced by ~/.bashrc on shell startup. It sets up the Scriptit
# environment by loading config, aliases, and environment variables.
# =============================================================================

export SCRIPTIT_DIR="$HOME/scriptit"
export SCRIPTS="$SCRIPTIT_DIR/scripts"

# -----------------------------------------------------------------------------
# BASE must be set in ~/.bashrc before sourcing this file. It is used
# throughout Scriptit to build paths to your projects.
# -----------------------------------------------------------------------------
if [ -z "$BASE" ]; then
    echo -e "\033[31mError: \$BASE is not set. Please add 'export BASE=/path/to/your/projects' to your ~/.bashrc before sourcing scriptit.\033[0m"
    return 1
fi

# -----------------------------------------------------------------------------
# Load environment variables from .env
# set -a exports all variables automatically, set +a turns this off after
# -----------------------------------------------------------------------------
if [ -f "$SCRIPTIT_DIR/.env" ]; then
    set -a
    source "$SCRIPTIT_DIR/.env"
    set +a
else
    echo -e "\033[33mWarning: .env not found\033[0m"
    return 1
fi

# -----------------------------------------------------------------------------
# Load all config files from config/
# Add new config by creating a .sh file in this directory
# -----------------------------------------------------------------------------
for config in "$SCRIPTIT_DIR/config"/*.sh; do
    [ -f "$config" ] && source "$config"
done

# -----------------------------------------------------------------------------
# Load all alias files from aliases/
# Add new aliases by creating a .sh file in this directory
# -----------------------------------------------------------------------------
for alias_file in "$SCRIPTIT_DIR/aliases"/*.sh; do
    [ -f "$alias_file" ] && source "$alias_file"
done

# -----------------------------------------------------------------------------
# Built-in aliases
# -----------------------------------------------------------------------------
alias reload="source ~/.bashrc"
alias bu-dbase="bash $SCRIPTS/backup-db.sh"
alias fix-line-endings="bash $SCRIPTS/fix-line-endings.sh"