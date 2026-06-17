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
# Database Selection
# =============================================================================
echo "Select database:"
for i in "${!DATABASES[@]}"; do
    echo "  $((i+1))) ${DATABASES[$i]}"
done
CUSTOM_DB_CHOICE=$(( ${#DATABASES[@]} + 1 ))
echo "  $CUSTOM_DB_CHOICE) Other (enter manually)"
read -p "Choice [1]: " DB_CHOICE

if [[ -z "$DB_CHOICE" || "$DB_CHOICE" == "1" ]]; then
    DB_NAME="${DATABASES[0]}"
elif [[ "$DB_CHOICE" == "$CUSTOM_DB_CHOICE" ]]; then
    read -p "Database name: " DB_NAME
else
    DB_INDEX=$(( DB_CHOICE - 1 ))
    DB_NAME="${DATABASES[$DB_INDEX]}"
fi

if [[ -z "$DB_NAME" ]]; then
    echo "Error: Database name cannot be empty"
    exit 1
fi

# =============================================================================
# Table Selection
# =============================================================================
CONTENT_TABLES="programs courses modules lessons quiz_questions quiz_answers dcos dco_hours scheduled_events videos posts"
USER_TABLES="users orders student_courses student_lessons student_answers"
PERMISSION_TABLES="model_has_permissions model_has_roles permissions role_has_permissions roles"

IMPORTANT_TABLES="$CONTENT_TABLES $PERMISSION_TABLES $USER_TABLES"

DEFAULT_EXCLUDED_TABLES="migrations cache cache_locks failed_jobs jobs job_batches password_reset_tokens sessions" 

EXCLUDED_TABLES="$DEFAULT_EXCLUDED_TABLES"

echo "Table selection:"
echo "  1) All tables (default)"
echo "  2) Important tables only (programs, courses, modules, lessons ...)"
echo "  3) Single table"
read -p "Choice [1]: " TABLE_CHOICE

case "$TABLE_CHOICE" in
    2) TABLE_NAME="$IMPORTANT_TABLES"; TABLE_LABEL="important-tables" ;;
    3) read -p "Table name: " TABLE_NAME; TABLE_LABEL="$TABLE_NAME" ;;
    *) TABLE_NAME=""; TABLE_LABEL="" ;;
esac

EXCLUDE_TABLE_ARGS=""
if [[ -z "$TABLE_LABEL" ]]; then
    for EXCLUDED_TABLE in $EXCLUDED_TABLES; do
        EXCLUDE_TABLE_ARGS+=" --ignore-table=${DB_NAME}.${EXCLUDED_TABLE}"
    done
else
    EXCLUDED_TABLES=""
fi

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

read -p "Continue with backup? (Y/n): " CONFIRM

if [[ "${CONFIRM:-y}" != "y" ]]; then
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
# BACKUP_FILE="fol_dbase.sql" # TEMP OVERRIDE
BACKUP_FILE="${DB_NAME}${TABLE_PART}${TYPE_PART}_${TIMESTAMP}.sql"

TABLE_ARG="${TABLE_NAME}"

# MYSQLDUMP_CMD="mysqldump --single-transaction $DUMP_FLAGS $DB_NAME $TABLE_ARG" # no headings
MYSQLDUMP_CMD="mysqldump --single-transaction --complete-insert $DUMP_FLAGS $DB_NAME $TABLE_ARG $EXCLUDE_TABLE_ARGS"

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
echo "✓ Backup complete: $LOCAL_BACKUP_DIR/$BACKUP_FILE" && \
[[ -n "$EXCLUDED_TABLES" ]] && echo "Note: excluded tables from the full backup: $EXCLUDED_TABLES"