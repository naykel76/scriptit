#!/bin/bash

SCRIPTIT_DIR="$HOME/scriptit"

echo "Fixing line endings in scriptit directory..."

# Fix all .sh files
find "$SCRIPTIT_DIR" -type f -name "*.sh" -exec sed -i 's/\r$//' {} +

# Fix .env file
if [ -f "$SCRIPTIT_DIR/.env" ]; then
    sed -i 's/\r$//' "$SCRIPTIT_DIR/.env"
fi

echo "✓ Line endings fixed"