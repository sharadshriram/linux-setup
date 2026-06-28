#!/usr/bin/env bash
#
# theme.sh — Applies one consistent color theme across:
#   - Kitty terminal
#   - GTK / GNOME shell (if running GNOME)
#   - VS Code (sets the color theme key in settings.json)
#   - Neovim (drops a colorscheme file your init.lua can require)
#
# Theme: Catppuccin Mocha (dark). Change THEME_NAME below to switch.
#
# Idempotent: safe to re-run.
#
# Usage:
#   bash theme.sh

set -euo pipefail

if [[ -z "${HOME:-}" ]]; then
  echo "HOME is not set — refusing to run (would write into /)." >&2
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_NAME="Catppuccin Mocha"

log()  { echo -e "\033[1;34m==>\033[0m $*"; }
warn() { echo -e "\033[1;33m!!\033[0m $*"; }
have() { command -v "$1" &>/dev/null; }

log "Applying theme: $THEME_NAME"

# ---------------------------------------------------------------------------
# Kitty terminal
# ---------------------------------------------------------------------------
KITTY_CONFIG_DIR="$HOME/.config/kitty"
if have kitty; then
  log "Configuring Kitty terminal colors"
  mkdir -p "$KITTY_CONFIG_DIR"

  cat > "$KITTY_CONFIG_DIR/theme.conf" <<'EOF'
# Managed by theme.sh — Catppuccin Mocha
foreground              #CDD6F4
background              #1E1E2E
selection_foreground    #1E1E2E
selection_background    #F5E0DC

cursor                  #F5E0DC
cursor_text_color       #1E1E2E

url_color               #F5E0DC

active_border_color     #B4BEFE
inactive_border_color   #6C7086
bell_border_color       #F9E2AF

active_tab_foreground   #11111B
active_tab_background   #CBA6F7
inactive_tab_foreground #CDD6F4
inactive_tab_background #181825
tab_bar_background      #11111B

# black
color0  #45475A
color8  #585B70
# red
color1  #F38BA8
color9  #F38BA8
# green
color2  #A6E3A1
color10 #A6E3A1
# yellow
color3  #F9E2AF
color11 #F9E2AF
# blue
color4  #89B4FA
color12 #89B4FA
# magenta
color5  #F5C2E7
color13 #F5C2E7
# cyan
color6  #94E2D5
color14 #94E2D5
# white
color7  #BAC2DE
color15 #A6ADC8
EOF

  # kitty.conf (symlinked by configs.sh) already ships with "include theme.conf".
  # This is just a safety net in case kitty.conf was hand-edited and lost it.
  if [[ -f "$KITTY_CONFIG_DIR/kitty.conf" ]] && ! grep -q '^include theme.conf' "$KITTY_CONFIG_DIR/kitty.conf"; then
    echo "include theme.conf" >> "$KITTY_CONFIG_DIR/kitty.conf"
  fi

  # Live-reload if kitty is currently running and remote control is enabled
  if have kitten; then
    kitten @ set-colors -a -c "$KITTY_CONFIG_DIR/theme.conf" 2>/dev/null || true
  fi
else
  warn "kitty not found — skipping terminal color setup"
fi

# ---------------------------------------------------------------------------
# GTK / GNOME shell theme (dark mode + accent)
# ---------------------------------------------------------------------------
if have gsettings && [[ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]]; then
  log "Setting GNOME to dark mode"
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || \
    warn "Could not set GNOME color-scheme (not running in a GNOME session?)"
  gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
else
  warn "No graphical session detected — skipping GNOME dark mode"
fi

# ---------------------------------------------------------------------------
# VS Code
# ---------------------------------------------------------------------------
VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
if [[ -f "$VSCODE_SETTINGS" || -L "$VSCODE_SETTINGS" ]]; then
  log "Setting VS Code color theme"
  if have jq; then
    TMP=$(mktemp)
    jq '. + {"workbench.colorTheme": "Catppuccin Mocha"}' "$VSCODE_SETTINGS" > "$TMP" && mv "$TMP" "$VSCODE_SETTINGS"
  else
    warn "jq not found — skipping VS Code settings.json patch. Install jq or set the theme manually."
  fi

  if have code; then
    log "Installing Catppuccin VS Code extension"
    code --install-extension Catppuccin.catppuccin-vsc --force >/dev/null 2>&1 || \
      warn "Could not install VS Code extension automatically — install 'Catppuccin' from the Extensions panel."
  fi
else
  warn "VS Code settings.json not found — run configs.sh first, then re-run theme.sh"
fi

# ---------------------------------------------------------------------------
# Neovim — drop a theme file the dotfiles config can source
# ---------------------------------------------------------------------------
NVIM_THEME_DIR="$REPO_DIR/dotfiles/nvim/lua/theme"
mkdir -p "$NVIM_THEME_DIR"
cat > "$NVIM_THEME_DIR/init.lua" <<'EOF'
-- Managed by theme.sh — sets the Catppuccin Mocha colorscheme.
-- Requires the catppuccin/nvim plugin to be installed via your plugin manager.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({ flavour = "mocha" })
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
EOF
log "Wrote Neovim theme module to $NVIM_THEME_DIR/init.lua"
log "Make sure your plugin manager requires 'theme' (e.g. via lazy.nvim's import)."

# ---------------------------------------------------------------------------
# Terminal color palette file (for tools that read a plain palette, e.g. fzf)
# ---------------------------------------------------------------------------
THEME_ENV_FILE="$REPO_DIR/dotfiles/zsh/theme.zsh"
cat > "$THEME_ENV_FILE" <<'EOF'
# Managed by theme.sh — Catppuccin Mocha palette for fzf and friends.
export FZF_DEFAULT_OPTS="
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"
EOF
log "Wrote fzf/terminal palette to $THEME_ENV_FILE (source this from .zshrc)"

log "Theme applied. Restart your terminal and VS Code for changes to fully take effect."
