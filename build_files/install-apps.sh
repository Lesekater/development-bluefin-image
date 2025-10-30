
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
    gimp.x86_64"

  ["fedora-multimedia"]="\
    HandBrake-cli \
    HandBrake-gui \
    vlc-plugin-bittorrent \
    vlc-plugin-ffmpeg \
    vlc-plugin-kde \
    vlc-plugin-pause-click \
    vlc \
    spotify-client"
)

# Add development packages only for Bluefin variants
if [[ $VARIANT_TYPE == "bluefin"* ]]; then
  RPM_PACKAGES["fedora"]="${RPM_PACKAGES["fedora"]} android-tools"
  log "Added development packages for $VARIANT_TYPE variant"
else
  log "Skipped development packages for $VARIANT_TYPE variant"
fi

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

log "Build process completed"
