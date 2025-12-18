#!/bin/bash
# File: setup.sh
# Description: Copy configs, prepare set_cam_state.sh with sudo permissions

CONFIG_SRC="$HOME/klipper-march/config"
CONFIG_DST="$HOME/printer_data/config"
CAM_SCRIPT="$HOME/klipper-march/scripts/set_cam_state.sh"

echo "Copying files from $CONFIG_SRC to $CONFIG_DST..."
mkdir -p "$CONFIG_DST"
cp -f "$CONFIG_SRC"/* "$CONFIG_DST"/

echo "Making $CAM_SCRIPT executable..."
chmod +x "$CAM_SCRIPT"

# Setup NOPASSWD for restarting crowsnest.service
SUDOERS_FILE="/etc/sudoers.d/klipper_crowsnest"

echo "Adding NOPASSWD sudo rule for crowsnest.service..."
sudo bash -c "cat > $SUDOERS_FILE" <<EOF
# Allow $USER to restart crowsnest.service without password
$USER ALL=(ALL) NOPASSWD: /bin/systemctl restart crowsnest.service
EOF

sudo chmod 440 "$SUDOERS_FILE"

echo "Setup complete. You can now use $CAM_SCRIPT without password for restarting crowsnest."
