#!/bin/bash

SCRIPTIT_DIR="$HOME/scriptit"

# Load .env with Windows line ending protection
if [ -f "$SCRIPTIT_DIR/.env" ]; then
    set -a
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ $key =~ ^#.*$ ]] && continue
        [[ -z $key ]] && continue
        # Clean value (remove carriage returns and whitespace)
        value=$(echo "$value" | sed 's/\r$//' | xargs)
        export "$key=$value"
    done < "$SCRIPTIT_DIR/.env"
    set +a
    echo -e "\033[32m.env loaded successfully.\033[0m"
else
    echo -e "\033[33mWarning: .env not found\033[0m"
    return 1
fi

# Load config
for config in "$SCRIPTIT_DIR/config"/*.sh; do
    [ -f "$config" ] && source "$config"
done

alias reload="source ~/.bashrc"