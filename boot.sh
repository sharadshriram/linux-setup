#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/.local/share/linux-setup"

sudo apt-get update
sudo apt-get install -y git

if [[ -d "$REPO_DIR" ]]; then
  git -C "$REPO_DIR" pull --ff-only
else
  git clone https://github.com/sharadshriram/linux-setup.git "$REPO_DIR"
fi

bash "$REPO_DIR/install.sh"
