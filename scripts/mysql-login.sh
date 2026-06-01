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

if [[ -z "$DBASE_USER" || -z "$DBASE_PWD" ]]; then
    echo "Error: DBASE_USER and DBASE_PWD must be set in .env"
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
# Mode Selection
# =============================================================================
echo ""
echo "Mode:"
echo "  1) Interactive session (default)"
echo "  2) Run a single SQL command"
read -p "Choice [1]: " MODE_CHOICE

if [[ "$MODE_CHOICE" == "2" ]]; then
    read -p "SQL: " SQL_CMD
    if [[ -z "$SQL_CMD" ]]; then
        echo "Error: SQL command cannot be empty"
        exit 1
    fi
fi

# =============================================================================
# Connect
# =============================================================================
echo ""
echo "Connecting to $DB_NAME on $SERVER..."
echo ""

MYSQL_CMD="mysql -u $DBASE_USER -p'$DBASE_PWD' $DB_NAME"

if [[ "$MODE_CHOICE" == "2" ]]; then
    ssh "$SERVER" "$MYSQL_CMD -e \"$SQL_CMD\""
else
    ssh -t "$SERVER" "$MYSQL_CMD"
fi
