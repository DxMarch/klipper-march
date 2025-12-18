#!/bin/bash
# Usage: ./set_cam_state.sh "SECTION_NAME" enable|disable
SECTION="$1"
ACTION="$2"
CONFIG="$HOME/printer_data/config/crowsnest.conf"

if [[ -z "$SECTION" || -z "$ACTION" ]]; then
  echo "Usage: $0 \"SECTION_NAME\" [enable|disable]"
  exit 1
fi

case "$ACTION" in
  enable)
    # Remove leading '#' in the section
    sed -i "/^\s*\[#\?\s*$SECTION\s*\]/,/^\s*\[/{ /^\s*\[/! s/^\s*#\s*// }" "$CONFIG"
    ;;
  disable)
    # Add leading '#' in the section if not present
    sed -i "/^\s*\[#\?\s*$SECTION\s*\]/,/^\s*\[/{ /^\s*\[/! s/^\(\s*\)\([^#]\)/\1# \2/ }" "$CONFIG"
    ;;
  *)
    echo "Invalid action: $ACTION"
    exit 1
    ;;
esac

sudo systemctl restart crowsnest.service
