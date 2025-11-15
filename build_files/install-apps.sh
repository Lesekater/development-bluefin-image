
trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

log "Processing variant type: ${VARIANT_TYPE:-unknown}"

# RPM packages list
declare -A RPM_PACKAGES=(
  ["fedora"]="\
    fzf \
    gparted \
    neovim \
    nmap \
    thefuck \
    fish \
    deja-dup \
    xdg-desktop-portal-hyprland"

  ["fedora-multimedia"]="\
    HandBrake-cli \
    HandBrake-gui \
    vlc-plugin-bittorrent \
    vlc-plugin-ffmpeg \
    vlc-plugin-kde \
    vlc-plugin-pause-click \
    vlc"

  ["copr:washkinazy/wayland-wm-extras"]="elephant walker"

  ["copr:solopasha/hyprland"]="hypridle hyprland hyprlock waybar waypaper"
)

# Add development packages only for Bluefin variants
# if [[ $VARIANT_TYPE == "bluefin"* ]]; then
#   #  development packages
# fi

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

log "Cleaning up package manager cache"
dnf5 clean all

log "Build process completed"
