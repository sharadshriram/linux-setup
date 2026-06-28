#!/usr/bin/env bash
#
# configs.sh — Symlinks dotfiles from this repo into your home directory.
#
# Plain bash symlinks (no GNU Stow). Existing real files are backed up
# with a .bak suffix before being replaced. Re-running is safe: if the
# symlink already points to the right place, it's left alone.
#
# Usage:
#   bash configs.sh

set -euo pipefail

if [[ -z "${HOME:-}" ]]; then
  echo "HOME is not set — refusing to run (would write into /)." >&2
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$REPO_DIR/dotfiles"

log()  { echo -e "\033[1;34m==>\033[0m $*"; }
warn() { echo -e "\033[1;33m!!\033[0m $*"; }

# link SRC DEST — creates a symlink DEST -> SRC, backing up any existing
# non-symlink file at DEST first.
link() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    # Already a symlink — check if it points where we want
    if [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
      return 0
    fi
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    warn "Backing up existing $dest -> ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi

  ln -s "$src" "$dest"
  log "Linked $dest -> $src"
}

# ---------------------------------------------------------------------------
# Shell configs
# ---------------------------------------------------------------------------
link "$DOTFILES_DIR/zsh/.zshrc"   "$HOME/.zshrc"
link "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"

# ---------------------------------------------------------------------------
# tmux
# ---------------------------------------------------------------------------
link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# ---------------------------------------------------------------------------
# kitty
# ---------------------------------------------------------------------------
link "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# ---------------------------------------------------------------------------
# Neovim — link the whole directory, not file by file
# ---------------------------------------------------------------------------
if [[ -d "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
  warn "Backing up existing ~/.config/nvim -> ~/.config/nvim.bak"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi
mkdir -p "$HOME/.config"
if [[ ! -L "$HOME/.config/nvim" ]]; then
  ln -s "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
  log "Linked ~/.config/nvim -> $DOTFILES_DIR/nvim"
fi

# ---------------------------------------------------------------------------
# VS Code
# ---------------------------------------------------------------------------
link "$DOTFILES_DIR/vscode/settings.json"     "$HOME/.config/Code/User/settings.json"
link "$DOTFILES_DIR/vscode/keybindings.json"  "$HOME/.config/Code/User/keybindings.json"

# ---------------------------------------------------------------------------
# git
# ---------------------------------------------------------------------------
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

log "Dotfiles linked."
