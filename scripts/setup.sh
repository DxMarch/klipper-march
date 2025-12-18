#!/bin/bash
# setup.sh — copy all configs from repo to printer_data/config

set -e

REPO_CONFIG_DIR="$(pwd)/config"
PRINTER_CONFIG_DIR="$HOME/printer_data/config"
BACKUP_DIR="$HOME/klipper_config_backup_$(date +%Y%m%d_%H%M%S)"

echo "Backing up existing files in $PRINTER_CONFIG_DIR to $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

# Backup existing files
for file in "$PRINTER_CONFIG_DIR"/*; do
    [ -e "$file" ] || continue
    cp -a "$file" "$BACKUP_DIR/"
done

echo "Copying files from $REPO_CONFIG_DIR to $PRINTER_CONFIG_DIR..."
mkdir -p "$PRINTER_CONFIG_DIR"

for file in "$REPO_CONFIG_DIR"/*; do
    [ -e "$file" ] || continue
    DEST="$PRINTER_CONFIG_DIR/$(basename "$file")"
    # Remove symlink or existing file if present
    [ -e "$DEST" ] && rm -f "$DEST"
    cp -a "$file" "$DEST"
    echo "Copied $(basename "$file")"
done

echo "Done. Backup of replaced files is in $BACKUP_DIR"
