#!/usr/bin/env bash
#
# install.sh — Idempotent setup for a Python/ML/agentic dev environment.
# Usage: bash install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$HOME/.linux-setup-install.log"

log()           { echo -e "\033[1;34m==>\033[0m $*" | tee -a "$LOG_FILE"; }
warn()          { echo -e "\033[1;33m!!\033[0m $*"  | tee -a "$LOG_FILE"; }
have()          { command -v "$1" &>/dev/null; }
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
  software-properties-common apt-transport-https \
  zsh zip tmux ripgrep fd-find fzf jq tree unzip htop \
  zoxide bat eza tldr kitty \
  shfmt shellcheck                   # shell formatter + linter (Google style)

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
  wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor \
    | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg >/dev/null
  echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$(dpkg --print-architecture)] \
    https://mise.jdx.dev/deb stable main" \
    | sudo tee /etc/apt/sources.list.d/mise.list
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
  uv tool install ruff    --quiet || true
  uv tool install pyright --quiet || true
  uv tool install yapf    --quiet || true   # Google Python Style formatter
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
if ! have claude && have npm; then
  log "Installing Claude Code CLI"
  npm install -g @anthropic-ai/claude-code
fi

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
  code --install-extension ms-python.python         --force
  code --install-extension charliermarsh.ruff       --force
  code --install-extension Catppuccin.catppuccin-vsc --force
  code --install-extension golang.go                --force
fi

# Chrome
if ! have google-chrome; then
  log "Installing Chrome"
  wget -qO /tmp/chrome.deb \
    "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  sudo apt-get install -y /tmp/chrome.deb
  rm -f /tmp/chrome.deb
fi

apt_install firefox

# Zotero
if ! have zotero; then
  log "Installing Zotero"
  curl -sL https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh \
    | sudo bash
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

# ---------------------------------------------------------------------------
# 11. Gnome extension and setup
# ---------------------------------------------------------------------------
sudo apt install -y gnome-shell-extension-manager pipx
pipx install gnome-extensions-cli --system-site-packages

# Turn off default Ubuntu extensions (safely ignore if not present, e.g. on Debian)
gnome-extensions disable tiling-assistant@ubuntu.com 2>/dev/null || true
gnome-extensions disable ubuntu-appindicators@ubuntu.com 2>/dev/null || true
gnome-extensions disable ubuntu-dock@ubuntu.com 2>/dev/null || true
gnome-extensions disable ding@rastersoft.com 2>/dev/null || true

# Pause to assure user is ready to accept confirmations
gum confirm "To install Gnome extensions, you need to accept some confirmations. Ready?"

# Install new extensions
gext install just-perfection-desktop@just-perfection
gext install blur-my-shell@aunetx
gext install space-bar@luchrioh
gext install undecorate@sun.wxg@gmail.com
gext install tophat@fflewddur.github.io
gext install AlphabeticalAppGrid@stuarthayhurst

# Compile gsettings schemas in order to be able to set them
sudo cp ~/.local/share/gnome-shell/extensions/just-perfection-desktop\@just-perfection/schemas/org.gnome.shell.extensions.just-perfection.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/blur-my-shell\@aunetx/schemas/org.gnome.shell.extensions.blur-my-shell.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/space-bar\@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/tophat@fflewddur.github.io/schemas/org.gnome.shell.extensions.tophat.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/AlphabeticalAppGrid\@stuarthayhurst/schemas/org.gnome.shell.extensions.AlphabeticalAppGrid.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/


# Configure Just Perfection
gsettings set org.gnome.shell.extensions.just-perfection animation 2
gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true
gsettings set org.gnome.shell.extensions.just-perfection workspace true
gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false

# Configure Blur My Shell
gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview pipeline 'pipeline_default'
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0

# Configure Space Bar
gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []"

# Configure TopHat
gsettings set org.gnome.shell.extensions.tophat show-icons false
gsettings set org.gnome.shell.extensions.tophat show-cpu false
gsettings set org.gnome.shell.extensions.tophat show-disk false
gsettings set org.gnome.shell.extensions.tophat show-mem false
gsettings set org.gnome.shell.extensions.tophat show-fs false
gsettings set org.gnome.shell.extensions.tophat network-usage-unit bits

# Configure AlphabeticalAppGrid
gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end'

# ---------------------------------------------------------------------------
# 12. Gnome settings and setup
# ---------------------------------------------------------------------------
# Center new windows in the middle of the screen
gsettings set org.gnome.mutter center-new-windows true

# Set Cascadia Mono as the default monospace font
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 13'

# Reveal week numbers in the Gnome calendar
gsettings set org.gnome.desktop.calendar show-weekdate true

# Turn off ambient sensors for setting screen brightness (they rarely work well!)
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false


log "Install complete — restart shell or log out/in."
