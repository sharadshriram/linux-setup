#!/usr/bin/env bash
#
# install.sh — Idempotent setup for a Python/ML/agentic dev environment.
# Usage: bash install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$HOME/.linux-setup-install.log"

log() { echo -e "\033[1;34m==>\033[0m $*" | tee -a "$LOG_FILE"; }
warn() { echo -e "\033[1;33m!!\033[0m $*" | tee -a "$LOG_FILE"; }
have() { command -v "$1" &>/dev/null; }
deb_installed() { dpkg -s "$1" &>/dev/null; }

apt_install() {
  local to_install=()
  for pkg in "$@"; do
    deb_installed "$pkg" || to_install+=("$pkg")
  done
  if [[ ${#to_install[@]} -gt 0 ]]; then
    log "apt: ${to_install[*]}"
    sudo apt-get install -y "${to_install[@]}"
  fi
}

trap 'warn "Failed at line $LINENO — re-run: bash $REPO_DIR/install.sh"' ERR

log "Starting install — log: $LOG_FILE"
sudo apt-get update -q

# ---------------------------------------------------------------------------
# 1. Base packages
# ---------------------------------------------------------------------------
apt_install \
  git curl wget build-essential ca-certificates gnupg lsb-release \
  apt-transport-https \
  zsh zip tmux ripgrep fd-find fzf jq tree unzip htop \
  zoxide bat eza kitty \
  shfmt shellcheck # shell formatter + linter (Google style)

# fd is packaged as fdfind on Debian/Ubuntu
if have fdfind && ! have fd; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

# batcat → bat alias
if have batcat && ! have bat; then
  mkdir -p "$HOME/.local/bin"
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
fi

# ---------------------------------------------------------------------------
# 2. Neovim — official tarball (Debian apt is ancient; need 0.10+ for LazyVim)
#    Installed to /opt/nvim-linux-x86_64, symlinked to /usr/local/bin/nvim.
#    PATH is managed in dotfiles/shell/exports.sh, not written here directly.
# ---------------------------------------------------------------------------
NVIM_MIN="0.10"
needs_nvim=false
if ! have nvim; then
  needs_nvim=true
elif [[ "$(nvim --version | head -n1 | grep -oP '\d+\.\d+' | head -1)" < "$NVIM_MIN" ]]; then
  needs_nvim=true
fi

if $needs_nvim; then
  log "Installing Neovim (latest stable tarball)"
  curl -fsSL -o /tmp/nvim-linux-x86_64.tar.gz \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim-linux-x86_64
  sudo tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  rm -f /tmp/nvim-linux-x86_64.tar.gz
else
  log "Neovim ok: $(nvim --version | head -n1)"
fi

# ---------------------------------------------------------------------------
# 3. mise (runtime manager) → Python 3.12 + Node LTS + Go latest
# ---------------------------------------------------------------------------
if ! have mise; then
  log "Installing mise"
  sudo apt-get install -y gpg wget
  sudo install -dm 755 /etc/apt/keyrings
  wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor |
    sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg >/dev/null
  echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$(dpkg --print-architecture)] \
    https://mise.jdx.dev/deb stable main" |
    sudo tee /etc/apt/sources.list.d/mise.list
  sudo apt-get update -q && sudo apt-get install -y mise
fi

if have mise; then
  log "Installing runtimes via mise"
  mise use --global python@3.12
  mise use --global node@lts
  mise use --global go@latest
fi

# ---------------------------------------------------------------------------
# 4. Python tooling (uv, ruff, pyright, yapf, jupyterlab)
# ---------------------------------------------------------------------------
if ! have uv; then
  log "Installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

if have uv; then
  log "Installing Python CLI tools via uv"
  uv tool install ruff --quiet || true
  uv tool install pyright --quiet || true
  uv tool install yapf --quiet || true # Google Python Style formatter
  uv tool install jupyterlab --quiet || true
fi

# ---------------------------------------------------------------------------
# 5. Node / TypeScript tooling (prettier, typescript, eslint)
#    These run via npx or project-local node_modules; installing globally
#    gives a system-wide fallback that conform.nvim can use.
# ---------------------------------------------------------------------------
if have npm; then
  log "Installing global Node tools"
  npm install -g prettier typescript typescript-language-server \
    @eslint/js eslint-config-google 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# 6. Agentic / AI tooling
# ---------------------------------------------------------------------------
if ! have agy; then
  log "Installing Antigravity CLI"
  curl -fsSL https://antigravity.google/cli/install.sh | bash
  export PATH="$HOME/.local/bin:$PATH"
fi

# ---------------------------------------------------------------------------
# 7. Desktop applications
# ---------------------------------------------------------------------------
# VS Code
if ! have code; then
  log "Installing VS Code"
  wget -qO /tmp/vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
  sudo apt-get install -y /tmp/vscode.deb
  rm -f /tmp/vscode.deb
fi

if have code; then
  code --install-extension ms-python.python --force
  code --install-extension charliermarsh.ruff --force
  code --install-extension Catppuccin.catppuccin-vsc --force
  code --install-extension golang.go --force
fi

# Chrome
if ! have google-chrome; then
  log "Installing Chrome"
  wget -qO /tmp/chrome.deb \
    "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  sudo apt-get install -y /tmp/chrome.deb
  rm -f /tmp/chrome.deb
fi

# Zotero
if ! have zotero; then
  log "Installing Zotero"
  curl -sL https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh |
    sudo bash
  apt_install zotero
fi

# Starship
if ! have starship; then
  log "Installing Starship prompt"
  curl -sS https://starship.rs/install.sh | sh -- --yes
fi

# ---------------------------------------------------------------------------
# 8. JetBrainsMono Nerd Font
#    Use the "Mono" style for terminals — forces glyphs to single-cell width.
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
fi

# ---------------------------------------------------------------------------
# 9. zsh as default shell
# ---------------------------------------------------------------------------
if [[ "$SHELL" != *zsh* ]]; then
  log "Setting zsh as default shell"
  sudo chsh -s "$(command -v zsh)" "$USER"
fi

# ---------------------------------------------------------------------------
# 10. Dotfiles + terminal plugin setup
# ---------------------------------------------------------------------------
log "Linking dotfiles"
bash "$REPO_DIR/configs.sh"

log "Setting up zsh plugins"
ZSH_PLUGIN_DIR="$HOME/.local/share/zsh/plugins"
mkdir -p "$ZSH_PLUGIN_DIR"
for repo in \
  "zsh-users/zsh-autosuggestions" \
  "zsh-users/zsh-syntax-highlighting" \
  "zsh-users/zsh-completions"; do
  plugin_name="${repo##*/}"
  plugin_dir="$ZSH_PLUGIN_DIR/$plugin_name"
  if [[ -d "$plugin_dir" ]]; then
    git -C "$plugin_dir" pull --ff-only -q
  else
    git clone --depth=1 "https://github.com/$repo.git" "$plugin_dir"
  fi
done

log "Setting up tmux plugins (TPM)"
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

log "Install complete — restart shell or log out/in."
