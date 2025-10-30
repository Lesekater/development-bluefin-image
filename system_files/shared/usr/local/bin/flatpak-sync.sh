#!/usr/bin/env bash
set -euo pipefail

APP_LIST_FILE="/etc/flatpak-sync/apps.txt"
APP_LIST_BLUEFIN="/etc/flatpak-sync/apps-bluefin.txt"
REMOTE_URL="https://dl.flathub.org/repo/flathub.flatpakrepo"
REMOTE_NAME="flathub"

# Ensure flathub remote exists
if ! flatpak remote-list | grep -q "$REMOTE_NAME"; then
  flatpak remote-add --if-not-exists "$REMOTE_NAME" "$REMOTE_URL"
fi

install_from_file() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    remote=${line%%:*}
    app=${line#*:}
    echo "Installing $app from $remote..."
    flatpak install -y "$remote" "$app" || true
  done < "$file"
}

# Install apps from the shared list
install_from_file "$APP_LIST_FILE"

# Additionally install Bluefin-only flatpaks if present
install_from_file "$APP_LIST_BLUEFIN"

