# Configure the bash shell using linux-setup defaults
[ -f "~/.bashrc" ] && mv ~/.bashrc ~/.bashrc.bak
cp ~/.local/share/linux-setup/configs/bashrc ~/.bashrc

# Load the PATH for use later in the installers
source ~/.local/share/linux-setup/defaults/bash/shell

[ -f "~/.inputrc" ] && mv ~/.inputrc ~/.inputrc.bak
# Configure the inputrc using linux-setup defaults
cp ~/.local/share/linux-setup/configs/inputrc ~/.inputrc