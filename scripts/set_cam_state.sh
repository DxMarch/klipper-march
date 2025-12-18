#!/bin/bash
SECTION="$1"
ACTION="$2"
CONFIG="$HOME/printer_data/config/crowsnest.conf"

if [[ -z "$SECTION" || -z "$ACTION" ]]; then
  echo "Usage: $0 \"section name\" [enable|disable]"
  exit 1
fi

if [[ "$ACTION" == "disable" ]]; then
  # Comment every line in the section (including header)
  sed -i "/^\s*#\?\s*\[${SECTION}\]/,/^\s*\[.*\]/ s/^\([^#]\)/# \1/" "$CONFIG"
elif [[ "$ACTION" == "enable" ]]; then
  # Uncomment every line in the section (including header)
  sed -i "/^\s*#\?\s*\[${SECTION}\]/,/^\s*\[.*\]/ s/^#\s*//" "$CONFIG"
else
  echo "Unknown action: $ACTION"
  exit 1
fi

sudo systemctl restart crowsnest.service
