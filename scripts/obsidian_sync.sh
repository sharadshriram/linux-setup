#!/bin/bash

# Configuration
VAULT_PATH="/home/sharadshriram/code/sharadshriram-vault"
LOG_FILE="/home/sharadshriram/scripts/obsidian_sync.log"

# Navigate to vault
cd "$VAULT_PATH" || exit

# 1. Pull changes (Syncs remote edits to your local machine)
/usr/bin/git pull origin main >> "$LOG_FILE" 2>&1

# 2. Check for changes
if [[ -n $(/usr/bin/git status -s) ]]; then
    # 3. Add and Commit
    /usr/bin/git add .
    /usr/bin/git commit -m "Automated backup: $(date +'%Y-%m-%d %H:%M:%S')"
    
    # 4. Push to GitHub
    /usr/bin/git push origin main >> "$LOG_FILE" 2>&1
    echo "$(date): Changes pushed to GitHub." >> "$LOG_FILE"
else
    echo "$(date): No changes detected. Skipping push." >> "$LOG_FILE"
fi
