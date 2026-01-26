#!/bin/bash

SCRIPTIT_DIR="$HOME/scriptit"

# Load .env
if [ -f "$SCRIPTIT_DIR/.env" ]; then
    export $(grep -v '^#' "$SCRIPTIT_DIR/.env" | xargs)
    echo -e "\033[32m.env loaded successfully.\033[0m"
else
    echo -e "\033[33mWarning: .env not found\033[0m"
    return 1
fi

# Load config
for config in "$SCRIPTIT_DIR/config"/*.sh; do
    [ -f "$config" ] && source "$config"
done