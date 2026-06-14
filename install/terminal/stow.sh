# Install and configure Stow dotfiles
set -e

echo "Setting up Stow..."

# Install GNU Stow if it's not installed
if ! command -v stow &> /dev/null; then
  echo "Installing GNU Stow..."
  sudo apt-get install -y stow >/dev/null
fi

# Function to backup existing files/folders if they are not symlinks
stow_backup_and_link() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Backing up existing non-symlink file/directory: $target to $target.bak"
    rm -rf "${target}.bak"
    mv "$target" "${target}.bak"
  fi
}

# Pre-create specific parent directories to prevent Stow from linking the entire parent directory
# We want to link files individually for VS Code and Tmux, but link the whole folder for Neovim.
mkdir -p ~/.config/tmux
mkdir -p ~/.config/Code/User

# Backup conflicting files/directories
stow_backup_and_link "$HOME/.bashrc"
stow_backup_and_link "$HOME/.inputrc"
stow_backup_and_link "$HOME/.zshrc"
stow_backup_and_link "$HOME/.Xcompose"
stow_backup_and_link "$HOME/.config/tmux/tmux.conf"
stow_backup_and_link "$HOME/.config/Code/User/settings.json"
stow_backup_and_link "$HOME/.config/nvim"

# Find the repository root dynamically based on the script location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Run Stow from the dotfiles directory
cd "$REPO_DIR/dotfiles"
echo "Stowing packages..."
stow -v -R -t "$HOME" bash zsh tmux vscode xcompose nvim

echo "Stow configurations completed successfully!"
