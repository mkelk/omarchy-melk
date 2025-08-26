echo "melk: Install KeePass"

# Check if keepass is already installed
if ! command -v keepass &>/dev/null; then
  echo "Installing KeePass from official repos..."
  if ! sudo pacman -Sy --noconfirm keepass; then
    echo "Failed to install KeePass"
    exit 1
  fi
  # Update locate database
  sudo updatedb
else
  echo "KeePass already installed"
fi

echo "✓ KeePass installation complete"
