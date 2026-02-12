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
alias bu-dbase="bash $SCRIPTS/backup-db.sh"
alias fix-line-endings="bash $SCRIPTS/fix-line-endings.sh"

# these should be moved to a custom config file later
alias sshfol="ssh -t $SSH_USER@$SERVER_IP 'cd /home/forge/factsoflife.com.au && bash -l'"
alias sshnk="ssh -t $SSH_USER@$SERVER_IP 'cd /home/forge/naykel.com.au && bash -l'"
alias sshzcc="ssh -t $SSH_USER@$SERVER_IP 'cd /home/forge/zakscues.com.au && bash -l'"
alias sshforge="ssh -t $SSH_USER@$SERVER_IP"

bu-zcc() {
    ssh forge@170.187.240.29 "cd /home/forge && tar --exclude='vendor' --exclude='node_modules' -czf zakscues-backup.tar.gz zakscues.com.au" \
    && scp forge@170.187.240.29:/home/forge/zakscues-backup.tar.gz ~/Downloads/ \
    && ssh forge@170.187.240.29 "rm /home/forge/zakscues-backup.tar.gz"
}

bu-zcc() {
    # Site configuration
    local SITE_NAME="zakscues.com.au"
    local OLD_SERVER="$SSH_USER@$OLD_SERVER_IP"
    local BACKUP_FILE="${SITE_NAME%.com.au}-backup.tar.gz"
    
    # Show backup details
    echo ""
    echo "=== Backup Details ==="
    echo "Server: $OLD_SERVER"
    echo "Site: $SITE_NAME"
    echo "Destination: $LOCAL_BACKUP_DIR"
    echo "====================="
    echo ""
    
    read -p "Continue with backup? (y/n): " CONFIRM
    
    if [[ "$CONFIRM" != "y" ]]; then
        echo "Backup cancelled"
        return 0
    fi
    
    # Execute backup process
    echo "Creating backup on server..." && \
    ssh $OLD_SERVER "cd $REMOTE_HOME && tar --exclude='vendor' --exclude='node_modules' -czf $BACKUP_FILE $SITE_NAME" && \
    
    echo "Downloading backup..." && \
    mkdir -p $LOCAL_BACKUP_DIR && \
    scp $OLD_SERVER:$REMOTE_HOME/$BACKUP_FILE $LOCAL_BACKUP_DIR/ && \
    
    echo "Cleaning up remote backup..." && \
    ssh $OLD_SERVER "rm $REMOTE_HOME/$BACKUP_FILE" && \
    
    echo "" && \
    echo "✓ Backup complete: $LOCAL_BACKUP_DIR/$BACKUP_FILE"
}
