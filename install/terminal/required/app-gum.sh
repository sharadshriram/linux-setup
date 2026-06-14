# Install gum: https://github.com/charmbracelet/gum
set -e

if ! command -v gum &> /dev/null; then
  echo "Installing gum (charm.sh CLI prompter)..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
  sudo apt-get update -y >/dev/null
  sudo apt-get install -y gum >/dev/null
fi
