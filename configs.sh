#!/usr/bin/env bash
#
# configs.sh — Symlinks dotfiles into $HOME.
# Plain bash symlinks, no GNU Stow. Existing real files get a .bak suffix.
# Re-running is safe: if the symlink already points correctly, it's a no-op.

set -euo pipefail

if [[ -z "${HOME:-}" ]]; then
  echo "HOME is not set — refusing to run." >&2
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$REPO_DIR/dotfiles"

log()  { echo -e "\033[1;34m==>\033[0m $*"; }
warn() { echo -e "\033[1;33m!!\033[0m $*"; }

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" ]]; then
    [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]] && return 0
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    warn "Backing up $dest → ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi
  ln -s "$src" "$dest"
  log "Linked $dest → $src"
}

# ---------------------------------------------------------------------------
# Shell — shared config files (sourced by both zsh and bash)
# ---------------------------------------------------------------------------
link "$DOTFILES_DIR/shell/exports.sh"   "$HOME/.config/shell/exports.sh"
link "$DOTFILES_DIR/shell/aliases.sh"   "$HOME/.config/shell/aliases.sh"
link "$DOTFILES_DIR/shell/functions.sh" "$HOME/.config/shell/functions.sh"

# ---------------------------------------------------------------------------
# Shells
# ---------------------------------------------------------------------------
link "$DOTFILES_DIR/zsh/.zshrc"     "$HOME/.zshrc"
link "$DOTFILES_DIR/bash/.bashrc"   "$HOME/.bashrc"

# ---------------------------------------------------------------------------
# tmux
# ---------------------------------------------------------------------------
link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# ---------------------------------------------------------------------------
# kitty
# ---------------------------------------------------------------------------
link "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

# ---------------------------------------------------------------------------
# Neovim — link the whole directory, not file by file.
# dotfiles/nvim/ maps directly to ~/.config/nvim/
# ---------------------------------------------------------------------------
if [[ -d "$HOME/.config/nvim" && ! -L "$HOME/.config/nvim" ]]; then
  warn "Backing up ~/.config/nvim → ~/.config/nvim.bak"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi
if [[ ! -L "$HOME/.config/nvim" ]]; then
  ln -s "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
  log "Linked ~/.config/nvim → $DOTFILES_DIR/nvim"
fi

# ---------------------------------------------------------------------------
# VS Code
# ---------------------------------------------------------------------------
link "$DOTFILES_DIR/vscode/settings.json"    "$HOME/.config/Code/User/settings.json"
link "$DOTFILES_DIR/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"

# ---------------------------------------------------------------------------
# git
# ---------------------------------------------------------------------------
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

log "Dotfiles linked."