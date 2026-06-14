# Install one of the most widely used editors and IDE

cd /tmp
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
rm -f packages.microsoft.gpg
cd -

sudo apt update -y
sudo apt install -y code

mkdir -p ~/.config/Code/User

# Install core development extensions
if command -v code &> /dev/null; then
  echo "Installing core VS Code extensions..."
  code --install-extension ms-python.python --force
  code --install-extension ms-python.vscode-pylance --force
  code --install-extension charliermarsh.ruff --force
  code --install-extension christian-kohnen.tmux-navigator --force
fi