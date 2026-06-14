# Zsh Configuration (linux-setup)

# Path to your installation
export SETUP_PATH="$HOME/.local/share/linux-setup"

# Set complete path
export PATH="./bin:$HOME/.local/bin:$SETUP_PATH/bin:$PATH"

# Set editor
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

# Source shared aliases if available
if [ -f "$SETUP_PATH/defaults/bash/aliases" ]; then
  source "$SETUP_PATH/defaults/bash/aliases"
fi

# Initialize mise (runtime manager) if available
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

# Initialize zoxide (cd replacement) if available
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# Initialize fzf if available
if command -v fzf &> /dev/null; then
  source <(fzf --zsh) 2>/dev/null || true
fi

# Zsh prompt with git integration
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %F{yellow}${vcs_info_msg_0_}%f$ '

# History settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# Autocompletion
autoload -Uz compinit
compinit
