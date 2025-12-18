#!/bin/bash
# setup.sh — copy configs from repo to printer_data/config

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

# Copy all .cfg and .conf files
for file in "$REPO_CONFIG_DIR"/*.{cfg,conf}; do
    [ -e "$file" ] || continue
    cp -f "$file" "$PRINTER_CONFIG_DIR/"
    echo "Copied $(basename "$file")"
done

echo "Done. Backup of replaced files is in $BACKUP_DIR"
