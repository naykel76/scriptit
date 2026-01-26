#!/bin/bash

SCRIPTIT_DIR="$HOME/scriptit"

# Load environment variables from .env
if [ -f "$SCRIPTIT_DIR/.env" ]; then
    set -a
    source "$SCRIPTIT_DIR/.env"
    set +a
else
    echo -e "\033[33mWarning: .env not found\033[0m"
    return 1
fi

# Load config
for config in "$SCRIPTIT_DIR/config"/*.sh; do
    [ -f "$config" ] && source "$config"
done

alias reload="source ~/.bashrc"

alias backup-db="bash $HOME/scriptit/scripts/backup-db.sh"

alias fix-line-endings="bash $HOME/scriptit/scripts/fix-line-endings.sh"
