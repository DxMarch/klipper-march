#!/bin/bash
# File: set_cam_state.sh
# Description: Enable or disable a section in crowsnest.conf

SECTION="$1"
ACTION="$2"
CONFIG="$HOME/printer_data/config/crowsnest.conf"
TMPFILE="$(mktemp)"

if [[ -z "$SECTION" || -z "$ACTION" ]]; then
  echo "Usage: $0 \"section name\" [enable|disable]"
  exit 1
fi

awk -v section_name="$SECTION" -v action="$ACTION" '
  # Detect section header (possibly commented)
  $0 ~ "^ *#? *\\[ *" section_name " *\\]" {in_section=1}

  # Exit section on any new header
  in_section && $0 ~ /^ *#? *\[/ && $0 !~ "^ *#? *\\[ *" section_name " *\\]" {in_section=0}

  # If in section, process according to flag
  in_section {
    if (action == "enable") { sub(/^ *#? */, "", $0); print $0; next }
    else if (action == "disable") { if ($0 !~ /^ *#/) print "# " $0; else print; next }
  }

  # Outside section: print as-is
  { print }
' "$CONFIG" > "$TMPFILE"

mv "$TMPFILE" "$CONFIG"