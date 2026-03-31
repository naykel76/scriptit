#!/usr/bin/env bash

# =============================================================================
# SERVER CONNECTION
# =============================================================================
export SERVER="$SSH_USER@$SERVER_IP"

# =============================================================================
# REMOTE PATHS
# (REMOTE_HOME and SITE_DIR set in .env)
# =============================================================================
export SITE_PATH="$REMOTE_HOME/$SITE_DIR"  # e.g. /home/forge/factsoflife.com.au

# All sites (used for interactive selection in scripts)
SITES=(
    "factsoflife.com.au"
    "naykel.com.au"
    "zakscues.com.au"
    fol.on-forge.com
)