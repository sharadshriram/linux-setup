#!/usr/bin/env bash
set -euo pipefail

# Detect desktop environment
DE="${XDG_CURRENT_DESKTOP:-none}"

source "$(dirname "$0")/install/terminal.sh"

if [[ "$DE" == *"GNOME"* ]] || [[ "$DE" == *"KDE"* ]] || [[ "$DE" == *"XFCE"* ]]; then
  source "$(dirname "$0")/install/desktop.sh"
else
  echo "No desktop environment detected — skipping desktop tools."
fi
