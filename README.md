# Elias development os
https://github.com/Lesekater/development-bluefin-image

Opinionated custom bootc image for development and daily use, with inspirations from [amyos](https://github.com/astrovm/amyos).

> [!WARNING]
> This Distribution is intentionally kept general enough to be installed on any System.
> HOWEVER - Since this is my personal OS, its not guaranteed to be stable and I wouldn't recommend using it as your primary OS.

## Variants

All variants are built daily from the same Containerfile, only the base image changes.
I have a bluefin-version of the OS, based on Bluefin DX (so with development tools pre-installed) with NVIDIA drivers (`development-bluefin-image-bluefin`) and without (`...-laptop`).
This repo includes also a Bazzite variant with NVIDIA drivers (`development-bluefin-image-bazzite`).

## Features

- Hyprland (from [lionheartp/Hyprland](https://copr.fedorainfracloud.org/coprs/lionheartp/Hyprland/)) with waybar, wofi, hyprlock, hypridle and waypaper
- General cli tools like: fish, neovim, tmux, fzf, thefuck, nmap, gparted and deja-dup
- Flatpaks get installed by a daily `flatpak-sync` timer (see `system_files/shared/etc/flatpak-sync/apps.txt`)
- `brew-sync` user timer that installs everything from `~/.config/Brewfile` 

---

## Installation

1. Install any bootc based system (e.g. Bluefin or Bazzite).
2. Switch to the image. (`sudo bootc switch ghcr.io/lesekater/development-bluefin-image`)
3. Reboot.

Switching between variants works the same way, just add the variant suffix.

## Credits

Based on the [ublue-os/image-template](https://github.com/ublue-os/image-template).
