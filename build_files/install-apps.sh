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
    fish"

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

# install other apps
# curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod

# log "Enabling system services"
# systemctl enable docker.socket libvirtd.service

# log "Adding just recipes"
# echo "import \"/usr/share/elias/just/reeding.just\"" >>/usr/share/ublue-os/justfile

# log "Hide incompatible Bazzite just recipes"
# for recipe in "install-coolercontrol" "install-openrgb"; do
#   if ! grep -l "^$recipe:" /usr/share/ublue-os/just/*.just | grep -q .; then
#     echo "Error: Recipe $recipe not found in any just file"
#     exit 1
#   fi
#   sed -i "s/^$recipe:/_$recipe:/" /usr/share/ublue-os/just/*.just
# done

log "Build process completed"