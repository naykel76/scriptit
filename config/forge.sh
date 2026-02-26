#!/usr/bin/env bash

# =============================================================================
# SERVER CONNECTION
# =============================================================================
export SERVER="$SSH_USER@$SERVER_IP"

# =============================================================================
# REMOTE PATHS
# Note: Hardcoded for now - may become function parameters later
# =============================================================================
export REMOTE_HOME="/home/forge"

# Site directories
export SITE_DIR="factsoflife.com.au"
export SITE_PATH="$REMOTE_HOME/$SITE_DIR"

# Backup paths
export BACKUP_NAME="${SITE_DIR}.tar.gz"
export REMOTE_BACKUP="$REMOTE_HOME/backups/$BACKUP_NAME"