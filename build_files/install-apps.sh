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

# Install Flatpaks
log "Installing Flatpaks"
if [[ -f /repo_files/flatpaks ]]; then
  while read -r flatpak_id; do
    [[ -z "$flatpak_id" ]] && continue
    flatpak install -y flathub "$flatpak_id"
  done < /repo_files/flatpaks
fi

log "Build process completed"