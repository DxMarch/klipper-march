#!/bin/bash

# Paths
REPO_CONFIG_DIR="$HOME/klipper-march/config"
KLIPPER_CONFIG_DIR="$HOME/printer_data/config/"
BACKUP_DIR="$HOME/klipper_config_backup_$(date +%Y%m%d_%H%M%S)"

# Create backup folder
mkdir -p "$BACKUP_DIR"

# Loop through all files in the repo config dir
for file in "$REPO_CONFIG_DIR"/*; do
    filename=$(basename "$file")
    target="$KLIPPER_CONFIG_DIR/$filename"

    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "Backing up existing file $filename"
        mv "$target" "$BACKUP_DIR/"
    fi

    echo "Creating symlink for $filename"
    ln -s "$file" "$target"
done

echo "Done. Backup of replaced files is in $BACKUP_DIR"
