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

#!/usr/bin/env bash
#
# install.sh — Installs all packages, runtimes, and applications.
#
# Idempotent: safe to re-run any time. Each block checks before installing.
#
# Usage:
#   bash install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$HOME/.linux-setup-install.log"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
log()      { echo -e "\033[1;34m==>\033[0m $*" | tee -a "$LOG_FILE"; }
warn()     { echo -e "\033[1;33m!!\033[0m $*" | tee -a "$LOG_FILE"; }
have()     { command -v "$1" &>/dev/null; }
deb_installed() { dpkg -s "$1" &>/dev/null; }

apt_install() {
  # apt_install pkg1 pkg2 ...  — only installs packages not already present
  local to_install=()
  for pkg in "$@"; do
    if ! deb_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done
  if [[ ${#to_install[@]} -gt 0 ]]; then
    log "Installing apt packages: ${to_install[*]}"
    sudo apt-get install -y "${to_install[@]}"
  fi
}

trap 'warn "install.sh failed at line $LINENO. Re-run: bash $REPO_DIR/install.sh"' ERR

log "Starting install — logging to $LOG_FILE"

# ---------------------------------------------------------------------------
# 1. System update + base packages
# ---------------------------------------------------------------------------
log "Updating apt package index"
sudo apt-get update

log "Installing base packages"
apt_install \
  git curl wget build-essential ca-certificates gnupg lsb-release \
  software-properties-common apt-transport-https \
  zsh tmux ripgrep fd-find fzf jq tree unzip htop eza

# fd is packaged as fdfind on Debian/Ubuntu — symlink to `fd`
if have fdfind && ! have fd; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

# ---------------------------------------------------------------------------
# 2. Neovim (latest stable, not the stale apt version)
# ---------------------------------------------------------------------------
if ! have nvim || [[ "$(nvim --version | head -n1 | grep -oP '\d+\.\d+' | head -1)" < "0.10" ]]; then
  log "Installing Neovim (latest stable AppImage)"
  curl -fsSL -o /tmp/nvim.appimage \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  chmod +x /tmp/nvim.appimage
  sudo mv /tmp/nvim.appimage /usr/local/bin/nvim
else
  log "Neovim already installed: $(nvim --version | head -n1)"
fi

# ---------------------------------------------------------------------------
# 3. mise (runtime manager) + Python + Node
# ---------------------------------------------------------------------------
if ! have mise; then
  log "Installing mise (runtime manager)"
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

if have mise; then
  log "Installing Python + Node via mise"
  mise use --global python@3.12
  mise use --global node@lts
fi

# ---------------------------------------------------------------------------
# 4. Python / ML tooling
# ---------------------------------------------------------------------------
if ! have uv; then
  log "Installing uv (Python package/venv manager)"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

if have uv; then
  log "Installing Python CLI tools (ruff, pyright, jupyterlab) via uv"
  uv tool install ruff --quiet || true
  uv tool install pyright --quiet || true
  uv tool install jupyterlab --quiet || true
fi

# ---------------------------------------------------------------------------
# 5. Agentic / AI tooling
# ---------------------------------------------------------------------------
if ! have claude && have npm; then
  log "Installing Claude Code CLI"
  npm install -g @anthropic-ai/claude-code
fi

# ---------------------------------------------------------------------------
# 6. VS Code
# ---------------------------------------------------------------------------
if ! have code; then
  log "Installing VS Code"
  wget -qO /tmp/vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
  sudo apt-get install -y /tmp/vscode.deb
  rm -f /tmp/vscode.deb
else
  log "VS Code already installed"
fi

# ---------------------------------------------------------------------------
# 7. Browsers
# ---------------------------------------------------------------------------
if ! have google-chrome; then
  log "Installing Google Chrome"
  wget -qO /tmp/chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  sudo apt-get install -y /tmp/chrome.deb
  rm -f /tmp/chrome.deb
else
  log "Chrome already installed"
fi

apt_install firefox

# ---------------------------------------------------------------------------
# 8. Zotero
# ---------------------------------------------------------------------------
if ! have zotero; then
  log "Installing Zotero"
  curl -sL https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | sudo bash
  apt_install zotero
else
  log "Zotero already installed"
fi

# ---------------------------------------------------------------------------
# 9. Obsidian
# ---------------------------------------------------------------------------
if ! have obsidian; then
  log "Installing Obsidian"
  OBSIDIAN_URL=$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
    | grep "browser_download_url.*amd64.deb" | cut -d '"' -f4)
  if [[ -n "$OBSIDIAN_URL" ]]; then
    wget -qO /tmp/obsidian.deb "$OBSIDIAN_URL"
    sudo apt-get install -y /tmp/obsidian.deb
    rm -f /tmp/obsidian.deb
  else
    warn "Could not resolve latest Obsidian .deb URL — skipping"
  fi
else
  log "Obsidian already installed"
fi

# ---------------------------------------------------------------------------
# 10. Fonts (JetBrains Mono Nerd Font — needed for terminal + nvim icons)
# ---------------------------------------------------------------------------
FONT_DIR="$HOME/.local/share/fonts"
if [[ ! -d "$FONT_DIR/JetBrainsMono" ]]; then
  log "Installing JetBrainsMono Nerd Font"
  mkdir -p "$FONT_DIR/JetBrainsMono"
  curl -fsSL -o /tmp/JetBrainsMono.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -oq /tmp/JetBrainsMono.zip -d "$FONT_DIR/JetBrainsMono"
  rm -f /tmp/JetBrainsMono.zip
  fc-cache -f "$FONT_DIR" >/dev/null
else
  log "JetBrainsMono Nerd Font already installed"
fi

# ---------------------------------------------------------------------------
# 11. Set zsh as default shell
# ---------------------------------------------------------------------------
if [[ "$SHELL" != *zsh* ]]; then
  log "Setting zsh as default shell"
  sudo chsh -s "$(command -v zsh)" "$USER"
else
  log "zsh already the default shell"
fi

# ---------------------------------------------------------------------------
# 12. Apply dotfiles + theme
# ---------------------------------------------------------------------------
log "Linking dotfiles"
bash "$REPO_DIR/configs.sh"

log "Applying terminal setup"
bash "$REPO_DIR/terminal.sh"

log "Install complete. Restart your shell or log out/in for all changes to take effect."
