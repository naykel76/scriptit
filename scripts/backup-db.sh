#!/usr/bin/env bash

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
# Table Selection
# =============================================================================
IMPORTANT_TABLES="courses iblce_outlines lessons model_has_permissions model_has_roles modules permissions posts quiz_answers quiz_questions role_has_permissions roles scheduled_events student_answers student_courses student_lessons users videos"

echo "Table selection:"
echo "  1) All tables (default)"
echo "  2) Important tables only (courses, modules, lessons ...)"
echo "  3) Single table"
read -p "Choice [1]: " TABLE_CHOICE

case "$TABLE_CHOICE" in
    2) TABLE_NAME="$IMPORTANT_TABLES"; TABLE_LABEL="important-tables" ;;
    3) read -p "Table name: " TABLE_NAME; TABLE_LABEL="$TABLE_NAME" ;;
    *) TABLE_NAME=""; TABLE_LABEL="" ;;
esac

# =============================================================================
# Backup Type
# =============================================================================
echo "Backup type:"
echo "  1) Full — schema + data (default)"
echo "  2) Data only"
echo "  3) Schema only"
read -p "Choice [1]: " BACKUP_TYPE_CHOICE

case "$BACKUP_TYPE_CHOICE" in
    2) DUMP_FLAGS="--no-create-info"; TYPE_LABEL="data-only" ;;
    3) DUMP_FLAGS="--no-data";        TYPE_LABEL="schema-only" ;;
    *) DUMP_FLAGS="";                 TYPE_LABEL="full" ;;
esac

# =============================================================================
# Show Backup Details and Confirm
# =============================================================================
echo ""
echo "=== Backup Details ==="
echo "Server: $SERVER"
echo "Database: $DB_NAME"
if [[ -n "$TABLE_LABEL" ]]; then
    echo "Tables: $TABLE_NAME"
fi
echo "Type: $TYPE_LABEL"
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
# Filename pattern: dbname[_table][_type]_TIMESTAMP.sql
TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
TABLE_PART="${TABLE_LABEL:+_${TABLE_LABEL}}"
TYPE_PART=$([ "$TYPE_LABEL" != "full" ] && echo "_${TYPE_LABEL}" || echo "")
BACKUP_FILE="${DB_NAME}${TABLE_PART}${TYPE_PART}_${TIMESTAMP}.sql"

TABLE_ARG="${TABLE_NAME}"
MYSQLDUMP_CMD="mysqldump --single-transaction $DUMP_FLAGS $DB_NAME $TABLE_ARG"

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