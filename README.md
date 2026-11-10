# Elias development os
https://github.com/Lesekater/development-bluefin-image

Opinionated custom bootc image for development and daily use, with inspirations from [amyos](https://github.com/astrovm/amyos).

## Variants

All variants are built daily from the same Containerfile, only the base image changes.

**Main** (`development-bluefin-image`): Bluefin DX with NVIDIA, for workstations  
**Bluefin** (`development-bluefin-image-bluefin`): same as main  
**Bluefin Laptop** (`development-bluefin-image-bluefin-laptop`): Bluefin DX without NVIDIA, for laptops  
**Bazzite** (`development-bluefin-image-bazzite`): Bazzite with NVIDIA, for gaming  

## Features

- Hyprland (from [lionheartp/Hyprland](https://copr.fedorainfracloud.org/coprs/lionheartp/Hyprland/)) with waybar, wofi, hyprlock, hypridle and waypaper
- fish, neovim, tmux, fzf, thefuck, nmap, gparted and deja-dup
- Flatpaks get installed by a daily `flatpak-sync` timer (see `system_files/shared/etc/flatpak-sync/apps.txt`)
- `brew-sync` user timer that installs everything from `~/.config/Brewfile`
- ROCm removed to save space

---

## Installation

1. Install any bootc based system (e.g. Bluefin or Bazzite).
2. Switch to the image. (`sudo bootc switch ghcr.io/lesekater/development-bluefin-image`)
3. Reboot.

Switching between variants works the same way, just add the variant suffix.

## Development

Packages are in `build_files/install-apps.sh`, files that get copied into the image are in `system_files/` (`shared/` for all variants, `<variant>/` for a single one). The variants themselves are defined in the matrix of `.github/workflows/build.yml`.

To build locally use `just build-all` or `just build-main`, `just --list` shows everything else.

Based on the [ublue-os/image-template](https://github.com/ublue-os/image-template).
