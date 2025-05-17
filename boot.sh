# Exit immediately if a command exits with a non-zero status
set -e

sudo apt-get update >/dev/null
sudo apt-get install -y git >/dev/null

echo "Cloning Setup..."
rm -rf ~/.local/share/linux-setup
git clone https://github.com/sharadshriram/linux-setup.git ~/.local/share/linux-setup >/dev/null


echo "Installation starting..."
source ~/.local/share/linux-setup/install.sh