# Source the repository's bash defaults
if [ -f ~/.local/share/linux-setup/defaults/bash/rc ]; then
  source ~/.local/share/linux-setup/defaults/bash/rc
fi

# Editor used by CLI
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
