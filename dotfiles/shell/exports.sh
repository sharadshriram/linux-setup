# dotfiles/shell/exports.sh
# Sourced by both .zshrc and .bashrc. Edit once, works in both shells.

# PATH — explicit ordering matters
# /usr/local/bin first: Neovim tarball symlink, user-installed binaries
# ~/.local/bin: uv, pipx, cargo, agy, mise itself
# mise shims: Python 3.12, Node LTS, Go (activated before this by eval)
export PATH="/usr/local/bin:$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

# Go (mise installs Go; GOPATH is where `go install` tools land)
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"

# Python / ML
export HF_HOME="$HOME/.cache/huggingface"
export TOKENIZERS_PARALLELISM=false

# fzf — use fd for faster file traversal
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

# Less
export LESS="-R"
export LESSHISTFILE="/dev/null"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"