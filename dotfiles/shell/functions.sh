# dotfiles/shell/functions.sh
# Sourced by both .zshrc and .bashrc.

# Compress a directory
compress()   { tar -czf "${1%/}.tar.gz" "${1%/}"; }
decompress() { tar -xzf "$1"; }

# Convert webm (GNOME screen recorder) to mp4
webm2mp4() {
  local input="$1"
  local output="${input%.webm}.mp4"
  ffmpeg -i "$input" -c:v libx264 -preset slow -crf 22 -c:a aac -b:a 192k "$output"
}

# Write an ISO to an SD card
iso2sd() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: iso2sd <iso_file> <device>"
    echo "Example: iso2sd ~/Downloads/ubuntu.iso /dev/sda"
    lsblk -d -o NAME | grep -E '^sd[a-z]' | awk '{print "/dev/"$1}'
    return 1
  fi
  sudo dd bs=4M status=progress oflag=sync if="$1" of="$2"
  sudo eject "$2"
}

# Create a Chrome web app desktop launcher
web2app() {
  if [[ $# -ne 3 ]]; then
    echo "Usage: web2app <AppName> <AppURL> <IconURL (PNG)>"
    return 1
  fi
  local name="$1" url="$2" icon_url="$3"
  local icon_dir="$HOME/.local/share/applications/icons"
  local desktop="$HOME/.local/share/applications/${name}.desktop"
  local icon="${icon_dir}/${name}.png"
  mkdir -p "$icon_dir"
  curl -sL -o "$icon" "$icon_url" || { echo "Icon download failed"; return 1; }
  cat > "$desktop" <<EOF
[Desktop Entry]
Version=1.0
Name=${name}
Exec=google-chrome --app="${url}" --name="${name}" --class="${name}" --window-size=800,600
Terminal=false
Type=Application
Icon=${icon}
Categories=GTK;
StartupNotify=true
EOF
  chmod +x "$desktop"
}

web2app-remove() {
  [[ $# -ne 1 ]] && { echo "Usage: web2app-remove <AppName>"; return 1; }
  rm -f "$HOME/.local/share/applications/${1}.desktop"
  rm -f "$HOME/.local/share/applications/icons/${1}.png"
}

# Quick directory bookmark
mkb()  { echo "$(pwd)" >> "$HOME/.bookmarks"; echo "Bookmarked: $(pwd)"; }
lsb()  { cat "$HOME/.bookmarks" 2>/dev/null || echo "No bookmarks yet"; }
cdb()  { cd "$(fzf < "$HOME/.bookmarks")"; }