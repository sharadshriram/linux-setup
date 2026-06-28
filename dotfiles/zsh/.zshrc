# ~/.zshrc — managed by linux-setup (dotfiles/zsh/.zshrc)

# ---------------------------------------------------------------------------
# Shared environment (PATH, EDITOR, exports) — sourced before everything else
# ---------------------------------------------------------------------------
[[ -f "$HOME/.config/shell/exports.sh" ]] && source "$HOME/.config/shell/exports.sh"

# ---------------------------------------------------------------------------
# zsh options
# ---------------------------------------------------------------------------
setopt AUTO_CD              # type a dir name to cd into it
setopt CORRECT              # suggest corrections for mistyped commands
setopt HIST_IGNORE_DUPS     # don't record consecutive duplicate commands
setopt HIST_IGNORE_SPACE    # don't record commands starting with a space
setopt HIST_REDUCE_BLANKS   # remove extra blanks from history
setopt SHARE_HISTORY        # share history across terminal sessions
setopt EXTENDED_HISTORY     # record timestamp in history
setopt AUTO_PUSHD           # cd pushes old dir onto stack
setopt PUSHD_IGNORE_DUPS    # don't push duplicate dirs
setopt INTERACTIVE_COMMENTS # allow # comments in interactive shell

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# ---------------------------------------------------------------------------
# Completion
# ---------------------------------------------------------------------------
autoload -Uz compinit

# Only re-initialise completion once per day (big startup speedup)
if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ---------------------------------------------------------------------------
# Shared aliases and functions
# ---------------------------------------------------------------------------
[[ -f "$HOME/.config/shell/aliases.sh" ]]   && source "$HOME/.config/shell/aliases.sh"
[[ -f "$HOME/.config/shell/functions.sh" ]] && source "$HOME/.config/shell/functions.sh"

# ---------------------------------------------------------------------------
# Plugins (installed by terminal.sh into ~/.local/share/zsh/plugins/)
# ---------------------------------------------------------------------------
ZSH_PLUGINS="$HOME/.local/share/zsh/plugins"

[[ -f "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"

[[ -f "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
  source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

[[ -f "$ZSH_PLUGINS/zsh-completions/zsh-completions.plugin.zsh" ]] && \
  source "$ZSH_PLUGINS/zsh-completions/zsh-completions.plugin.zsh"

# ---------------------------------------------------------------------------
# fzf — key bindings (Ctrl-R history, Ctrl-T file, Alt-C dir)
# ---------------------------------------------------------------------------
if have fzf; then
  source <(fzf --zsh) 2>/dev/null || true
fi

# ---------------------------------------------------------------------------
# Runtime managers
# ---------------------------------------------------------------------------
have mise    && eval "$(mise activate zsh)"
have zoxide  && eval "$(zoxide init zsh --cmd cd)"  # replaces cd with z

# ---------------------------------------------------------------------------
# Prompt (starship — install.sh installs it; fallback to vcs_info)
# ---------------------------------------------------------------------------
if have starship; then
  eval "$(starship init zsh)"
else
  autoload -Uz vcs_info
  precmd() { vcs_info }
  zstyle ':vcs_info:git:*' formats '(%b) '
  PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %F{yellow}${vcs_info_msg_0_}%f$ '
fi