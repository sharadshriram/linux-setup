# Install uv - fast Python package manager (Astral)
set -e

if ! command -v uv &> /dev/null; then
  echo "Installing uv (fast Python package manager)..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
