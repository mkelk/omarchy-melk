echo "melk: Install Google Chrome as default browser"

# Check if google-chrome is already installed
if ! command -v google-chrome &>/dev/null; then
  echo "Installing Google Chrome from AUR..."
  if ! yay -Sy --noconfirm google-chrome; then
    echo "Failed to install Google Chrome"
    exit 1
  fi
  # Update locate database like omarchy-pkg-aur-install does
  sudo updatedb
else
  echo "Google Chrome already installed"
fi

# Set Google Chrome as the default browser
echo "Setting Google Chrome as default browser..."
xdg-settings set default-web-browser google-chrome.desktop
xdg-mime default google-chrome.desktop x-scheme-handler/http
xdg-mime default google-chrome.desktop x-scheme-handler/https

echo "✓ Google Chrome is now the default browser"
