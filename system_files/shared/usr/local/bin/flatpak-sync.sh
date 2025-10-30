#!/usr/bin/env bash
set -euo pipefail

APP_LIST_FILE="/etc/flatpak-sync/apps.txt"
REMOTE_URL="https://dl.flathub.org/repo/flathub.flatpakrepo"
REMOTE_NAME="flathub"

# Ensure flathub remote exists
if ! flatpak remote-list | grep -q "$REMOTE_NAME"; then
  flatpak remote-add --if-not-exists "$REMOTE_NAME" "$REMOTE_URL"
fi

# Install apps from list
while IFS= read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  remote=${line%%:*}
  app=${line#*:}
  echo "Installing $app from $remote..."
  flatpak install -y "$remote" "$app" || true
done < "$APP_LIST_FILE"

