# dotfiles/shell/aliases.sh
# Sourced by both .zshrc and .bashrc. All aliases work in both shells.

# ---------------------------------------------------------------------------
# File system (using eza for ls, zoxide for cd)
# ---------------------------------------------------------------------------
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='eza -lha --group-directories-first --icons=auto'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='eza --tree --level=2 --long --icons --git -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias cat='bat --pager=never'        # bat as cat replacement

# zoxide — but only alias cd if zoxide is available
# (zoxide is activated by shell-specific init, alias is safe in both)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ---------------------------------------------------------------------------
# Editors
# ---------------------------------------------------------------------------
alias n='nvim'
alias vi='nvim'
alias vim='nvim'

# ---------------------------------------------------------------------------
# Git
# ---------------------------------------------------------------------------
alias g='git'
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gb='git branch'
alias gco='git checkout'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gp='git push'
alias gpl='git pull'
alias lzg='lazygit'

# ---------------------------------------------------------------------------
# Python / ML
# ---------------------------------------------------------------------------
alias py='python3'
alias pip='pip3'
alias venv='uv venv .venv && source .venv/bin/activate'
alias activate='source .venv/bin/activate 2>/dev/null || source venv/bin/activate'
alias jlab='jupyter lab --no-browser'

# ---------------------------------------------------------------------------
# Tmux
# ---------------------------------------------------------------------------
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'

# ---------------------------------------------------------------------------
# Kitty
# ---------------------------------------------------------------------------
alias icat='kitten icat'
alias kdiff='kitten diff'

# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------
alias d='docker'
alias lzd='lazydocker'

# ---------------------------------------------------------------------------
# System
# ---------------------------------------------------------------------------
alias ports='ss -tulanp'
alias df='df -h'
alias du='du -h'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias fix_fkeys='echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode'