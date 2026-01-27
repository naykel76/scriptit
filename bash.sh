#!/bin/bash

export SCRIPTIT_DIR="$HOME/scriptit"
export SCRIPTS="$SCRIPTIT_DIR/scripts"

# Check if BASE is set
if [ -z "$BASE" ]; then
    echo -e "\033[31mError: \$BASE is not set. Please add 'export BASE=/path/to/your/projects' to your ~/.bashrc before sourcing scriptit.\033[0m"
    return 1
fi

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

# script aliases
alias backup-db="bash $SCRIPTS/backup-db.sh"
alias fix-line-endings="bash $SCRIPTS/fix-line-endings.sh"

# these should be moved to a custom config file later
alias sshfol="ssh -t $SSH_USER@$SERVER_IP 'cd /home/forge/factsoflife.com.au && bash -l'"
