# =============================================================================
# SERVER CONNECTION
# =============================================================================
export SERVER="$SSH_USER@$SERVER_IP"

# =============================================================================
# REMOTE PATHS
# =============================================================================
export REMOTE_HOME="/home/forge"

# Site directories
export SITE_DIR="factsoflife.com.au"
export SITE_PATH="$REMOTE_HOME/$SITE_DIR"

# Backup paths
export BACKUP_NAME="${SITE_DIR}.tar.gz"
export REMOTE_BACKUP="$REMOTE_HOME/backups/$BACKUP_NAME"




# # =============================================================================
# # LOCAL PATHS
# # =============================================================================
# export LOCAL_BACKUP_DIR="/mnt/c/users/natha/sites/server-backups"
# export LOCAL_BACKUP="$LOCAL_BACKUP_DIR/$BACKUP_NAME" # what is this used for?



# # # In .bashrc - add these after your existing config
# # STORAGE_ONLY_DIR="storage/app/public"
# # STORAGE_BACKUP_NAME="${SITE_DIR}-storage.tar.gz"
# # STORAGE_REMOTE_BACKUP="$REMOTE_HOME/backups/$STORAGE_BACKUP_NAME"
# # STORAGE_LOCAL_BACKUP="$LOCAL_BACKUP_DIR/$STORAGE_BACKUP_NAME"



# export NEW_SERVER_IP="134.199.156.68"
# export NEW_SSH_USER="forge"
# export NEW_SERVER="$NEW_SSH_USER@$NEW_SERVER_IP"

# # alias sshforge='ssh $SERVER'

# alias sshnk='ssh $NEW_SERVER -t "cd ~/naykel.com.au && bash"'


# # scp ~/server-backups/factsoflife.com.au-storage.tar.gz forge@$NEW_SERVER_IP:/home/forge/

# # scp /mnt/c/users/natha/sites/server-backups/factsoflife.com.au-storage.tar.gz forge@$NEW_SERVER_IP:/home/forge/