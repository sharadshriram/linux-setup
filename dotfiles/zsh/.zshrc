# ~/.zshrc — managed by linux-setup (dotfiles/zsh/.zshrc)

# ---------------------------------------------------------------------------
# Shared environment (PATH, EDITOR, exports)
# ---------------------------------------------------------------------------
[[ -f "$HOME/.config/shell/exports.sh" ]] && source "$HOME/.config/shell/exports.sh"

# have() — used throughout this file to guard optional tools
have() { command -v "$1" &>/dev/null; }

# ---------------------------------------------------------------------------
# zsh options
# ---------------------------------------------------------------------------
setopt AUTO_CD CORRECT HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt SHARE_HISTORY EXTENDED_HISTORY AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# ---------------------------------------------------------------------------
# Completion
# ---------------------------------------------------------------------------
autoload -Uz compinit
if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ---------------------------------------------------------------------------
# Shared aliases and functions
# ---------------------------------------------------------------------------
[[ -f "$HOME/.config/shell/aliases.sh" ]]   && source "$HOME/.config/shell/aliases.sh"
[[ -f "$HOME/.config/shell/functions.sh" ]] && source "$HOME/.config/shell/functions.sh"

# ---------------------------------------------------------------------------
# Plugins (cloned by install.sh into ~/.local/share/zsh/plugins/)
# ---------------------------------------------------------------------------
ZSH_PLUGINS="$HOME/.local/share/zsh/plugins"
[[ -f "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$ZSH_PLUGINS/zsh-completions/zsh-completions.plugin.zsh" ]] && \
  source "$ZSH_PLUGINS/zsh-completions/zsh-completions.plugin.zsh"

# ---------------------------------------------------------------------------
# fzf, mise, zoxide, starship
# ---------------------------------------------------------------------------
have fzf     && source <(fzf --zsh) 2>/dev/null || true
have mise    && eval "$(mise activate zsh)"
have zoxide  && eval "$(zoxide init zsh --cmd cd)"
have starship && eval "$(starship init zsh)"