#!/bin/sh
# This post install script works only for debian based, Gnome desktops.

# Download color themes for gnome-terminal
bash -c "$(curl -fsSL https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-dark.sh)"
bash -c "$(curl -L https://raw.githubusercontent.com/catppuccin/gnome-terminal/v1.0.0/install.py | python3 -)"

# Updates
sudo apt update
sudo apt upgrade
sudo apt dist-upgrade

# Installing deb packages
sudo apt install -y curl git neovim tmux python3-virtualenv virtualbox virtualbox-ext-pack firefox steam pipx

sudo apt install kdenlive gimp

# Install Solaar for Logitech devices
sudo apt install solaar

# Installing VS Code
cd /tmp
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
rm -f packages.microsoft.gpg
cd -
sudo apt update
sudo apt install -y code

# Power management
sudo apt install tlp tlp-rdw
sudo tlp start

# Install Google antigravity CLI
curl -fsSL https://antigravity.google/cli/install.sh | bash

# Install Google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

# Install Google Antigravity
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
  sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
  sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null
sudo apt update
sudo apt install antigravity

# Add Jetbrains Mono font
mkdir -p ~/.local/share/fonts/
unzip JetBrainsMono.zip -d ~/.local/share/fonts
fc-cache -f -v
echo "Set the JetBrainsMono font on terminal manually by changing settings"

# Install Catppuccin theme for tmux if not already present
if [ ! -d ~/.config/tmux/plugins/catppuccin ]; then
  mkdir -p ~/.config/tmux/plugins/catppuccin
  git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
fi

# Install zsh and fzf
sudo apt install -y zsh fzf

# Set zsh as the default shell
chsh -s $(which zsh)

# Configure zsh
mv ~/.zshrc ~/.zshrc.bkp
touch ~/.zshrc

# Using gnu stow for dotfiles
sudo apt install stow

# Cleanup
sudo apt clean
sudo apt autoremove
sudo apt autoclean

# Sync dotfiles with stow
bash ~/.local/share/linux-setup/install/terminal/stow.sh


## Notes
echo "For enabling Cappucin theme on gnome-terminal: Select from Edit -> Preferences."
echo "For GitHub SSH setup, refer: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent"
echo "dofiles/ will need to mimic the structure of the home directory"
