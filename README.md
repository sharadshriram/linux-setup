# linux-setup

One-command setup for a Python / ML / agentic-systems dev environment on
any Debian/Ubuntu machine.

## Quick Start

```bash
# Fresh machine — run this once:
curl -fsSL https://raw.githubusercontent.com/sharadshriram/linux-setup/main/boot.sh | bash

# Re-run on existing machine (idempotent):
bash ~/.local/share/linux-setup/install.sh

# Re-apply dotfiles only:
bash ~/.local/share/linux-setup/configs.sh

# Re-apply theme only (add vault path to also theme Obsidian... wait, removed):
bash ~/.local/share/linux-setup/theme.sh
```

## What Gets Installed

| Category | Tools |
|---|---|
| **Shell** | zsh (default), starship prompt, zsh-autosuggestions, zsh-syntax-highlighting |
| **Terminal** | Kitty (GPU-accelerated, ligatures, Catppuccin themed) |
| **Editor** | Neovim (AstroNvim v6, Catppuccin), VS Code (backup) |
| **Runtimes** | Python 3.12, Node LTS, Go (via mise) |
| **Python** | uv, ruff, pyright, yapf, jupyterlab |
| **TypeScript** | typescript-language-server, prettier, eslint |
| **Go** | gopls, goimports |
| **Agentic** | Claude Code CLI (`claude`), Antigravity CLI (`agy`) |
| **Browsers** | Chrome, Firefox |
| **Reference** | Zotero |
| **CLI tools** | tmux, fzf, ripgrep, fd, eza, bat, zoxide, jq, tldr |
| **Fonts** | JetBrainsMono Nerd Font (Mono variant for terminals) |

## Shell Cheatsheet

### Navigation
| Command | What it does |
|---|---|
| `cd foo` | Smart cd via zoxide (learns your frequent dirs) |
| `z foo` | Jump to most-used dir matching "foo" |
| `..` `...` `....` | Go up 1, 2, 3 directories |
| `Ctrl+R` | fzf history search |
| `Ctrl+T` | fzf file search, insert path |
| `Alt+C` | fzf directory search, cd into it |

### File System
| Alias | Expands to |
|---|---|
| `ls` | `eza -lh --icons --group-directories-first` |
| `lsa` | `eza -lha` (include hidden) |
| `lt` | `eza --tree --level=2` (tree view) |
| `ff` | fzf file picker with bat preview |
| `cat` | `bat --pager=never` (syntax highlighted) |
| `du` / `df` | human-readable disk usage |

### Git
| Alias | Command |
|---|---|
| `gs` | `git status` |
| `ga` | `git add` |
| `gd` | `git diff` |
| `gl` | `git log --oneline --graph --decorate` |
| `gcm "msg"` | `git commit -m "msg"` |
| `gcam "msg"` | `git commit -a -m "msg"` |
| `gp` | `git push` |
| `gpl` | `git pull` |
| `gco branch` | `git checkout branch` |
| `lzg` | lazygit (TUI git client) |

### Python / ML
| Alias/Command | What it does |
|---|---|
| `venv` | `uv venv .venv && source .venv/bin/activate` |
| `activate` | Source the nearest venv |
| `jlab` | Start JupyterLab (no browser) |
| `py` | `python3` |
| `uv add <pkg>` | Add package to current project |
| `uv run script.py` | Run script in project venv |

### Functions
| Function | Usage |
|---|---|
| `compress dir/` | Creates `dir.tar.gz` |
| `decompress file.tar.gz` | Extracts archive |
| `webm2mp4 file.webm` | Convert GNOME recording to mp4 |
| `iso2sd image.iso /dev/sda` | Write ISO to SD card |
| `web2app Name URL IconURL` | Create Chrome web-app launcher |
| `mkb` | Bookmark current directory |
| `lsb` | List bookmarks |
| `cdb` | fzf-pick a bookmark and cd |

### Tmux
| Keybinding | Action |
|---|---|
| `Ctrl+b "` | Split pane horizontally (preserves cwd) |
| `Ctrl+b %` | Split pane vertically (preserves cwd) |
| `Ctrl+h/j/k/l` | Navigate panes (works from Neovim too) |
| `Ctrl+b d` | Detach session |
| `Ctrl+b I` | Install plugins via TPM |
| `ta name` | Attach to named session |
| `tn name` | New named session |
| `tl` | List sessions |
| `tk name` | Kill session |

### Kitty Terminal
| Keybinding | Action |
|---|---|
| `Ctrl+Shift+Enter` | New window in same cwd |
| `Ctrl+Shift+T` | New tab in same cwd |
| `Ctrl+Shift+H/L/K/J` | Navigate windows |
| `Ctrl+Shift+Z` | Zoom current pane |
| `Ctrl+Shift+C/V` | Copy/Paste |
| `kitten icat image.png` | Display image inline |
| `kitten diff file1 file2` | Side-by-side diff |
| `kitten ssh host` | SSH with full kitty features |

## Neovim (AstroNvim) Cheatsheet

Leader key is `Space`.

### File & Buffer Navigation
| Key | Action |
|---|---|
| `<Space>ff` | Find files (Telescope) |
| `<Space>fg` | Live grep (ripgrep) |
| `<Space>fb` | Browse buffers |
| `<Space>fo` | Recent files |
| `<Space>e` | Toggle file explorer (Neo-tree) |
| `]b` / `[b` | Next / previous buffer |
| `<Space>bd` | Close buffer (pick from tabline) |

### LSP (Language Server)
| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<Space>la` | Code action |
| `<Space>lf` | Format file |
| `<Space>lr` | Rename symbol |
| `<Space>ls` | Document symbols |
| `[d` / `]d` | Previous / next diagnostic |
| `<Space>ld` | Show diagnostic float |

### Language-Specific
| Language | LSP | Formatter | Linter |
|---|---|---|---|
| Python | pyright | yapf (Google style) | ruff |
| Bash/sh | bashls | shfmt (-i 2 Google style) | shellcheck |
| TypeScript | ts_ls | prettier | eslint |
| Go | gopls | goimports | golangci-lint |
| JSON | jsonls | prettier | built-in schema |
| Markdown | marksman | prettier | markdownlint |

### Git
| Key | Action |
|---|---|
| `<Space>gg` | Open Lazygit |
| `<Space>gn` / `<Space>gp` | Next / prev git hunk |
| `<Space>gs` | Stage hunk |
| `<Space>gr` | Reset hunk |
| `<Space>gb` | Git blame |
| `<Space>gd` | Git diff |

### General
| Key | Action |
|---|---|
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>/` | Comment toggle |
| `<Space>n` | Clear search highlight |
| `<Space>u` | Open undo tree |
| `gcc` | Toggle line comment |
| `gc` (visual) | Toggle block comment |
| `<Space>?` | Which-key menu |
| `<Ctrl+\>` | Toggle floating terminal |

### Telescope
| Key | Action |
|---|---|
| `<Space>fk` | Search keymaps |
| `<Space>fh` | Search help tags |
| `<Space>fm` | Search man pages |
| `<Space>ft` | Search themes |

## Tool Highlights

### `fzf` — fuzzy finder
The backbone of fast navigation. Every `Ctrl+R` history search, `Ctrl+T` file
insert, and `Alt+C` directory jump uses it. The preview window uses `bat` for
syntax-highlighted file previews.

### `zoxide` — smart `cd`
Learns which directories you visit most. After a few sessions, `z foo` jumps
directly to the right place. Completely replaces habitual `cd ~/long/path/to/project`.

### `eza` — modern `ls`
Git-aware file listing with icons (needs JetBrainsMono Nerd Font). `lt` gives
an instant tree view of any directory. Git status columns show modified/staged state.

### `bat` — syntax-highlighted `cat`
All `cat` calls go through bat. The diff pager in git also uses bat. The `ff`
alias shows bat previews inside fzf.

### `mise` — runtime manager
Manages Python, Node, and Go versions per-project or globally. Replaces `pyenv`,
`nvm`, `asdf`. Config in `~/.tool-versions` or `mise.toml` per project. Shims
activate automatically when you enter a directory.

### `uv` — Python package manager
10-100x faster than pip. `uv venv` creates a venv, `uv add` installs into it,
`uv run` executes scripts without manual activation. `uv tool install` installs
CLI tools (ruff, pyright, yapf) in isolated environments.

### `starship` — cross-shell prompt
Shows git branch, language versions (Python, Node, Go), exit codes, and command
duration. Configured via `~/.config/starship.toml` (not included — defaults are
excellent). Same prompt in zsh, bash, and any other shell.

### `claude` (Claude Code CLI)
Agentic coding assistant in the terminal. `claude` opens an interactive session.
Can read/edit files, run tests, and execute commands with your approval.

### `agy` (Antigravity CLI)
Google's agentic CLI tool. Pairs with the Antigravity desktop IDE.

## Adding a New Machine

```bash
# 1. Clone and run (everything else is automatic):
curl -fsSL https://raw.githubusercontent.com/sharadshriram/linux-setup/main/boot.sh | bash

# 2. After install completes, open a new terminal and verify:
which nvim          # /usr/local/bin/nvim
nvim --version      # v0.11+
which python3       # ~/.local/share/mise/shims/python3
python3 --version   # 3.12.x
which node          # ~/.local/share/mise/shims/node
tmux -V             # tmux 3.x

# 3. Open Neovim — first launch installs all plugins automatically:
nvim

# 4. Inside Neovim, install tmux plugins:
# Open a tmux session, then press: Ctrl+b I
```

## Updating

```bash
# Update the repo and re-run install (safe to run anytime):
git -C ~/.local/share/linux-setup pull --ff-only
bash ~/.local/share/linux-setup/install.sh

# Update Neovim plugins:
# Inside nvim: :Lazy update

# Update Mason LSP tools:
# Inside nvim: :MasonUpdate

# Update runtimes (Python, Node, Go):
mise upgrade
```

## Repository Structure

```
linux-setup/
├── boot.sh              # Entry point for fresh machines
├── install.sh           # Idempotent full setup
├── configs.sh           # Symlinks dotfiles into $HOME
├── theme.sh             # Applies Catppuccin Mocha everywhere
├── dotfiles/
│   ├── shell/
│   │   ├── exports.sh   # PATH, EDITOR, env vars (shared zsh+bash)
│   │   ├── aliases.sh   # All aliases (shared zsh+bash)
│   │   └── functions.sh # Shell functions (shared zsh+bash)
│   ├── zsh/.zshrc
│   ├── bash/.bashrc
│   ├── tmux/tmux.conf
│   ├── kitty/
│   │   ├── kitty.conf
│   │   └── theme.conf   # Written by theme.sh
│   ├── nvim/            # AstroNvim v6 config → ~/.config/nvim/
│   │   ├── init.lua
│   │   └── lua/
│   │       ├── lazy_setup.lua
│   │       ├── community.lua  # Language packs + Catppuccin
│   │       ├── polish.lua
│   │       └── plugins/
│   │           ├── astrocore.lua   # Options, keymaps
│   │           ├── astrolsp.lua    # LSP behaviour
│   │           ├── astroui.lua     # Theme
│   │           ├── mason.lua       # Tool installer
│   │           ├── none-ls.lua     # Formatters/linters
│   │           ├── treesitter.lua  # Parsers
│   │           └── user.lua        # Custom overrides
│   ├── vscode/settings.json
│   └── git/.gitconfig
├── install/
│   ├── desktop/
│   │   ├── set-gnome-extensions.sh  # GNOME extensions (run manually)
│   │   └── set-gnome-settings.sh    # GNOME settings (run manually)
│   └── terminal/
└── scripts/
```