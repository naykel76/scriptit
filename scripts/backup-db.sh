#!/bin/bash

if [[ -z "$SERVER" ]]; then
    echo "Error: Forge config not loaded. Run 'source ~/.bashrc' first."
    exit 1
fi

# =============================================================================
# Get Database Name
# =============================================================================
# Prompt for database name
read -p "Database name: " DB_NAME

if [[ -z "$DB_NAME" ]]; then
    echo "Error: Database name cannot be empty"
    exit 1
fi

# =============================================================================
# Get Table Name (Optional)
# =============================================================================
read -p "Table name (leave blank for all tables): " TABLE_NAME

# =============================================================================
# Show Backup Details and Confirm
# =============================================================================
echo ""
echo "=== Backup Details ==="
echo "Server: $SERVER"
echo "Database: $DB_NAME"
if [[ -n "$TABLE_NAME" ]]; then
    echo "Table: $TABLE_NAME"
fi
echo "Destination: $LOCAL_BACKUP_DIR"
echo "====================="
echo ""

read -p "Continue with backup? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then
    echo "Backup cancelled"
    exit 0
fi

# =============================================================================
# Execute Backup Process
# =============================================================================
# Creates timestamped filename: dbname_20240126_143022.sql or dbname_tablename_20240126_143022.sql
if [[ -n "$TABLE_NAME" ]]; then
    BACKUP_FILE="${DB_NAME}_${TABLE_NAME}_$(date +%Y-%m-%d_%H%M%S).sql"
    MYSQLDUMP_CMD="mysqldump --single-transaction $DB_NAME $TABLE_NAME"
else
    BACKUP_FILE="${DB_NAME}_$(date +%Y-%m-%d_%H%M%S).sql"
    MYSQLDUMP_CMD="mysqldump --single-transaction $DB_NAME"
fi

# Step 1: Create backup on remote server
echo "Creating backup on server..."
ssh $SERVER "$MYSQLDUMP_CMD > ~/$BACKUP_FILE" && \

# Step 2: Download backup to local machine
echo "Downloading backup..." && \
mkdir -p $LOCAL_BACKUP_DIR && \
scp $SERVER:~/$BACKUP_FILE $LOCAL_BACKUP_DIR/ && \

# Step 3: Remove backup file from remote server to save space
echo "Cleaning up remote backup..." && \
ssh $SERVER "rm ~/$BACKUP_FILE" && \

# Step 4: Confirmation
echo "" && \
echo "✓ Backup complete: $LOCAL_BACKUP_DIR/$BACKUP_FILE"