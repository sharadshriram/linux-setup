# ~/.bashrc — managed by linux-setup (dotfiles/bash/.bashrc)
# Minimal fallback; zsh is the primary shell.

# Return early if not interactive
[[ $- != *i* ]] && return

# ---------------------------------------------------------------------------
# Shared environment
# ---------------------------------------------------------------------------
[[ -f "$HOME/.config/shell/exports.sh" ]]   && source "$HOME/.config/shell/exports.sh"
[[ -f "$HOME/.config/shell/aliases.sh" ]]   && source "$HOME/.config/shell/aliases.sh"
[[ -f "$HOME/.config/shell/functions.sh" ]] && source "$HOME/.config/shell/functions.sh"

# ---------------------------------------------------------------------------
# Bash options
# ---------------------------------------------------------------------------
shopt -s histappend checkwinsize autocd 2>/dev/null || true

HISTSIZE=50000
HISTFILESIZE=100000
HISTCONTROL=ignoredups:ignorespace

# ---------------------------------------------------------------------------
# Completion
# ---------------------------------------------------------------------------
if ! shopt -oq posix; then
  [[ -f /usr/share/bash-completion/bash_completion ]] && \
    source /usr/share/bash-completion/bash_completion
fi

# ---------------------------------------------------------------------------
# Runtime managers
# ---------------------------------------------------------------------------
command -v mise   &>/dev/null && eval "$(mise activate bash)"
command -v zoxide &>/dev/null && eval "$(zoxide init bash --cmd cd)"

# ---------------------------------------------------------------------------
# fzf key bindings (Ctrl-R, Ctrl-T, Alt-C)
# ---------------------------------------------------------------------------
[[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]] && \
  source /usr/share/doc/fzf/examples/key-bindings.bash

# ---------------------------------------------------------------------------
# Prompt
# ---------------------------------------------------------------------------
if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
else
  PS1='\[\033[00;32m\]\u@\h:\[\033[00;34m\]\w\[\033[00m\]$(git branch 2>/dev/null | sed -n "s/* \(.*\)/ (\1)/p")\$ '
fi