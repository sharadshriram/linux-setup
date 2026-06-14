# My Linux Setup (Ubuntu-based Gnome)

A minimal, automated Linux setup and configuration repository inspired by [Omakub](https://github.com/basecamp/omakub), designed to keep environment settings synchronized across multiple machines.

It uses **GNU Stow** to manage configuration files (dotfiles) as symlinks from the home directory to the cloned repository.

---

## 🚀 Setup a Fresh Ubuntu Install

If you are on an old Ubuntu version, consider upgrading to the current LTS release (24.04+):

```bash
sudo apt update
sudo apt upgrade
sudo apt dist-upgrade
sudo apt install update-manager-core
sudo reboot
```

Once the updates are done and reboot is complete, start the distribution upgrade (this will be a time-consuming step):

```bash
sudo do-release-upgrade
```

---

## 🛠️ Installation

You can bootstrap this setup on a fresh machine by running the following command:

```bash
curl -fsSL https://raw.githubusercontent.com/sharadshriram/linux-setup/main/boot.sh | bash
```

This will:
1. Clone this repository to `~/.local/share/linux-setup`.
2. Install all terminal packages, runtimes (via `mise`), and desktop applications.
3. Automatically link all configuration files from the `dotfiles/` folder to your home directory using GNU Stow.

---

## 📦 How the Dotfiles Sync Works (GNU Stow)

All configuration files are organized in the `dotfiles/` directory by application package (e.g. `bash`, `zsh`, `tmux`, `vscode`, `nvim`, `xcompose`).

Stow creates symlinks in your home directory pointing to the files in the repository:
- `~/.bashrc` ➔ `~/.local/share/linux-setup/dotfiles/bash/.bashrc`
- `~/.zshrc` ➔ `~/.local/share/linux-setup/dotfiles/zsh/.zshrc`
- `~/.config/tmux/tmux.conf` ➔ `~/.local/share/linux-setup/dotfiles/tmux/.config/tmux/tmux.conf`
- `~/.config/Code/User/settings.json` ➔ `~/.local/share/linux-setup/dotfiles/vscode/.config/Code/User/settings.json`
- `~/.config/nvim/` ➔ `~/.local/share/linux-setup/dotfiles/nvim/.config/nvim/`

### 🔄 Syncing Changes Across Machines

#### 1. Making changes on Machine A
Since your home directory configurations are symlinks directly pointing to the git repository:
1. Simply edit your configuration file (e.g., your `.zshrc` or Neovim settings in `~/.config/nvim`).
2. Go to the repository directory:
   ```bash
   cd ~/.local/share/linux-setup
   ```
3. Commit and push your changes to GitHub:
   ```bash
   git add dotfiles/
   git commit -m "Update shell/nvim configurations"
   git push origin main
   ```

#### 2. Pulling changes on Machine B
On your other machine:
1. Pull the updates from GitHub:
   ```bash
   cd ~/.local/share/linux-setup
   git pull origin main
   ```
2. Re-apply the symlinks (if new files were added) by running:
   ```bash
   bash ~/.local/share/linux-setup/install/terminal/stow.sh
   ```

---

## 📁 Repository Structure

- `dotfiles/` - Configuration files managed by GNU Stow.
- `install/` - Shell scripts to install terminal and desktop software.
- `defaults/` - Base settings and modular shell imports (aliases, path additions, etc.).
- `themes/` - Color schemes and desktop background customizations.
- `uninstall/` - Uninstallation scripts for individual applications.


