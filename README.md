# linux-setup

A minimal, idempotent setup for a Python / ML / agentic-systems dev
environment on any Debian-based Linux machine.

Four scripts, each with one job:

| Script | Responsibility |
|---|---|
| `install.sh` | Installs all packages, runtimes, and applications. The single entrypoint — calls the other three at the end. |
| `configs.sh` | Symlinks dotfiles from `dotfiles/` into your home directory (plain `ln -s`, no GNU Stow). |
| `terminal.sh` | Sets up the interactive shell: zsh plugins, the `starship` prompt, tmux plugin manager. |
| `theme.sh` | Applies one consistent color theme (Catppuccin Mocha) across terminal, GTK/GNOME, VS Code, and Neovim. |

## Quick start

```bash
git clone https://github.com/sharadshriram/linux-setup.git ~/.local/share/linux-setup
cd ~/.local/share/linux-setup
bash install.sh
```

`install.sh` installs everything, then automatically runs `configs.sh` and
`terminal.sh` for you. Run `theme.sh` separately whenever you want to
(re)apply the color theme — it's independent on purpose, so you can restyle
without reinstalling anything.

```bash
bash theme.sh
```

Every script is **idempotent** — re-run any of them any time. They check
before installing or linking, so nothing is duplicated or clobbered.
Existing real config files are backed up to `<file>.bak` before being
replaced with a symlink.

## What gets installed

- **Shell:** zsh (default) + bash, with `starship` prompt, autosuggestions,
  syntax highlighting, fzf
- **Terminal:** Kitty
- **Editors:** Neovim (latest stable), VS Code
- **Python / ML:** `mise` (runtime manager), `uv`, `ruff`, `pyright`,
  JupyterLab
- **Agentic tooling:** Claude Code CLI
- **Browsers:** Google Chrome, Firefox
- **Reference / notes:** Zotero, Obsidian
- **Fonts:** JetBrainsMono Nerd Font

## How dotfiles work

`dotfiles/` mirrors your home directory structure. `configs.sh` symlinks
each file/directory into place:

```
dotfiles/zsh/.zshrc          -> ~/.zshrc
dotfiles/bash/.bashrc        -> ~/.bashrc
dotfiles/tmux/tmux.conf      -> ~/.config/tmux/tmux.conf
dotfiles/kitty/kitty.conf    -> ~/.config/kitty/kitty.conf
dotfiles/nvim/               -> ~/.config/nvim/   (whole directory)
dotfiles/vscode/settings.json -> ~/.config/Code/User/settings.json
dotfiles/git/.gitconfig      -> ~/.gitconfig
```

Because these are symlinks, editing `~/.zshrc` directly edits the file in
the repo. To sync changes to another machine:

```bash
cd ~/.local/share/linux-setup
git add dotfiles/ && git commit -m "update zshrc" && git push

# on the other machine
cd ~/.local/share/linux-setup
git pull
bash configs.sh   # only needed if new files were added
```

## Theming

`theme.sh` is separate from `install.sh` so you can change your color
scheme without touching packages. It:

- Writes `~/.config/kitty/theme.conf` with the Catppuccin Mocha palette and
  live-reloads it via `kitten @ set-colors` if Kitty is running
- Sets GTK to dark mode (skipped gracefully on non-GNOME or headless systems)
- Patches `~/.config/Code/User/settings.json` to use the Catppuccin VS Code
  theme and installs the extension
- Writes `dotfiles/nvim/lua/theme/init.lua`, a lazy.nvim module that sets
  the Neovim colorscheme
- Writes `dotfiles/zsh/theme.zsh` with a matching `fzf` color palette

To change the theme, edit `THEME_NAME` and the color values at the top of
`theme.sh`.

## Repository structure

```
linux-setup/
├── install.sh           # Single entrypoint: packages + runtimes + apps
├── configs.sh            # Symlinks dotfiles into $HOME
├── terminal.sh            # zsh plugins, starship, tmux plugin manager
├── theme.sh                # Color theme across terminal/VS Code/Neovim/GTK
├── dotfiles/
│   ├── zsh/.zshrc
│   ├── bash/.bashrc
│   ├── tmux/tmux.conf
│   ├── kitty/{kitty.conf, theme.conf}
│   ├── nvim/init.lua
│   ├── vscode/{settings.json, keybindings.json}
│   └── git/.gitconfig
└── README.md
```
