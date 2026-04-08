#!/usr/bin/env bash

SCRIPTIT_DIR="${SCRIPTIT_DIR:-$HOME/scriptit}"

if [[ -f "$SCRIPTIT_DIR/.env" ]]; then
    set -a; source "$SCRIPTIT_DIR/.env"; set +a
fi

source "$SCRIPTIT_DIR/config/forge.sh"

if [[ -z "$SERVER" ]]; then
    echo "Error: Could not load Forge config from $SCRIPTIT_DIR"
    exit 1
fi

# =============================================================================
# Site Selection
# =============================================================================
echo "Select site:"
DEFAULT_SITE_INDEX=0
for i in "${!SITES[@]}"; do
    if [[ "${SITES[$i]}" == "$SITE_DIR" ]]; then
        DEFAULT_SITE_INDEX=$i
        echo "  $((i+1))) ${SITES[$i]} (default)"
    else
        echo "  $((i+1))) ${SITES[$i]}"
    fi
done
read -p "Choice [$((DEFAULT_SITE_INDEX+1))]: " SITE_CHOICE

if [[ -z "$SITE_CHOICE" ]]; then
    SITE_INDEX=$DEFAULT_SITE_INDEX
else
    SITE_INDEX=$(( SITE_CHOICE - 1 ))
fi
SELECTED_SITE="${SITES[$SITE_INDEX]}"

if [[ -z "$SELECTED_SITE" ]]; then
    echo "Error: Invalid site selection"
    exit 1
fi

SITE_PATH="$REMOTE_HOME/$SELECTED_SITE"

# =============================================================================
# Remote Path Selection
# =============================================================================
echo ""
echo "What to back up:"
echo "  1) Full site (default)"
for i in "${!SITE_LOCATIONS[@]}"; do
    echo "  $((i+2))) ${SITE_LOCATIONS[$i]}"
done
CUSTOM_CHOICE=$(( ${#SITE_LOCATIONS[@]} + 2 ))
echo "  $CUSTOM_CHOICE) Custom path"
read -p "Choice [1]: " PATH_CHOICE

if [[ -z "$PATH_CHOICE" || "$PATH_CHOICE" == "1" ]]; then
    REMOTE_PATH="$SITE_PATH"
    PATH_LABEL="$SELECTED_SITE"
elif [[ "$PATH_CHOICE" == "$CUSTOM_CHOICE" ]]; then
    read -p "Remote path: " REMOTE_PATH
    PATH_LABEL=$(basename "$REMOTE_PATH")
else
    LOCATION_INDEX=$(( PATH_CHOICE - 2 ))
    REMOTE_PATH="$SITE_PATH/${SITE_LOCATIONS[$LOCATION_INDEX]}"
    PATH_LABEL=$(basename "${SITE_LOCATIONS[$LOCATION_INDEX]}")
fi

if [[ -z "$REMOTE_PATH" ]]; then
    echo "Error: Remote path cannot be empty"
    exit 1
fi


# =============================================================================
# Excludes
# =============================================================================
DEFAULT_EXCLUDES="--exclude=node_modules --exclude=.git --exclude=vendor"

echo ""
echo "Default excludes: node_modules, .git, vendor"
read -p "Additional excludes (space-separated, or leave blank): " EXTRA_EXCLUDES

EXCLUDE_ARGS="$DEFAULT_EXCLUDES"
for excl in $EXTRA_EXCLUDES; do
    EXCLUDE_ARGS="$EXCLUDE_ARGS --exclude=$excl"
done

# =============================================================================
# Show Backup Details and Confirm
# =============================================================================
TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
BACKUP_FILE="${PATH_LABEL}_${TIMESTAMP}.tar.gz"
REMOTE_TMP="$REMOTE_HOME/$BACKUP_FILE"

echo ""
echo "=== Backup Details ==="
echo "Server:      $SERVER"
echo "Remote path: $REMOTE_PATH"
echo "Archive:     $BACKUP_FILE"
echo "Destination: $LOCAL_BACKUP_DIR"
echo "====================="
echo ""

read -p "Continue with backup? (Y/n): " CONFIRM

if [[ "${CONFIRM:-y}" != "y" ]]; then
    echo "Backup cancelled"
    exit 0
fi

# =============================================================================
# Execute Backup Process
# =============================================================================

# Step 1: Create archive on remote server
echo "Creating archive on server..."
ssh $SERVER "tar -czf $REMOTE_TMP $EXCLUDE_ARGS -C $(dirname $REMOTE_PATH) $(basename $REMOTE_PATH)" || {
    echo "Error: Failed to create archive on server"
    exit 1
}

# Step 2: Download archive to local machine
echo "Downloading archive..."
mkdir -p "$LOCAL_BACKUP_DIR"
scp "$SERVER:$REMOTE_TMP" "$LOCAL_BACKUP_DIR/" || {
    echo "Error: Failed to download archive"
    ssh $SERVER "rm -f $REMOTE_TMP"
    exit 1
}

# Step 3: Remove archive from remote server
echo "Cleaning up remote archive..."
ssh $SERVER "rm $REMOTE_TMP"

# Step 4: Confirmation
echo ""
echo "✓ Backup complete: $LOCAL_BACKUP_DIR/$BACKUP_FILE"
