#!/usr/bin/bash
set -euo pipefail

trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

# RPM packages list
declare -A RPM_PACKAGES=(
  ["fedora"]="\
    android-tools \
    fzf \
    gparted \
    neovim \
    nmap \
    thefuck \
    fish \
    rawtherapee \
    spotify-client \
    deja-dup \
    Signal-Desktop"

  ["terra"]="\
    starship"

#   ["rpmfusion-free,rpmfusion-free-updates,rpmfusion-nonfree,rpmfusion-nonfree-updates"]="\
#     audacious \
#     audacious-plugins-freeworld \
#     audacity-freeworld"

  ["fedora-multimedia"]="\
    HandBrake-cli \
    HandBrake-gui \
    vlc-plugin-bittorrent \
    vlc-plugin-ffmpeg \
    vlc-plugin-kde \
    vlc-plugin-pause-click \
    vlc"
)

log "Starting build process"

log "Installing RPM packages"
mkdir -p /var/opt
for repo in "${!RPM_PACKAGES[@]}"; do
  read -ra pkg_array <<<"${RPM_PACKAGES[$repo]}"
  if [[ $repo == copr:* ]]; then
    # Handle COPR packages
    copr_repo=${repo#copr:}
    dnf5 -y copr enable "$copr_repo"
    dnf5 -y install "${pkg_array[@]}"
    dnf5 -y copr disable "$copr_repo"
  else
    # Handle regular packages
    [[ $repo != "fedora" ]] && enable_opt="--enable-repo=$repo" || enable_opt=""
    cmd=(dnf5 -y install)
    [[ -n "$enable_opt" ]] && cmd+=("$enable_opt")
    cmd+=("${pkg_array[@]}")
    "${cmd[@]}"
  fi
done

# flatpak packages list
declare -A FLATPAK_PACKAGES=(
  ["flathub"]="\
    com.usebottles.bottles \
    org.blender.Blender \
    org.gimp.GIMP \
    org.libreoffice.LibreOffice \
    org.signal.Signal \
    org.telegram.desktop \
    com.discordapp.Discord"
)

# Install Flatpaks
log "Installing Flatpaks"
for repo in "${!FLATPAK_PACKAGES[@]}"; do
  for flatpak_id in ${FLATPAK_PACKAGES[$repo]}; do
    [[ -z "$flatpak_id" ]] && continue
    if ! flatpak remote-list | grep -q "^$repo\s"; then
      flatpak remote-add --if-not-exists "$repo" "https://flathub.org/repo/$repo.flatpakrepo"
    fi
    if ! flatpak list --app | grep -q "^$flatpak_id\s"; then
      flatpak install -y "$repo" "$flatpak_id"
    else
      log "$flatpak_id is already installed, skipping."
    fi
  done
done

log "Build process completed"