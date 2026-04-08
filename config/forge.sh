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
    "fol.on-forge.com"
)

# Databases (used for interactive selection in scripts)
DATABASES=(
    "fol_dbase"
    "fol_dev_dbase"
    "nk_dbase"
)

# Common backup locations (relative to site root)
SITE_LOCATIONS=(
    "storage/app/public/content"
    "storage/app/public/courses"
    "storage/app/public/media-documents"
    "storage/app/public/media-downloads"
    "storage/app/public/media-videos"
    "storage/app/public/videos"
)