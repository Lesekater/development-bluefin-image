# Elias development os

Opinionated custom bootc image for development and daily use, with inspirations from [amyos](https://github.com/astrovm/amyos). Built on top of [Universal Blue](https://universal-blue.org/) images.

## Variants

All variants are built from the same Containerfile, only the base image changes.

| Variant | Image | Base | For |
|---------|-------|------|-----|
| **Main** | `ghcr.io/lesekater/development-bluefin-image` | `bluefin-dx-nvidia-open` | Workstations with NVIDIA GPUs |
| **Bluefin** | `ghcr.io/lesekater/development-bluefin-image-bluefin` | `bluefin-dx-nvidia-open` | Same as main |
| **Bluefin Laptop** | `ghcr.io/lesekater/development-bluefin-image-bluefin-laptop` | `bluefin-dx` | Laptops without a dedicated GPU |
| **Bazzite** | `ghcr.io/lesekater/development-bluefin-image-bazzite` | `bazzite-nvidia` | Gaming with NVIDIA GPUs |

Images are rebuilt daily and signed with cosign (see `cosign.pub`).

## Features

- Hyprland (from [lionheartp/Hyprland](https://copr.fedorainfracloud.org/coprs/lionheartp/Hyprland/)) with waybar, wofi, hyprlock, hypridle and waypaper
- CLI tools: fish, neovim, tmux, fzf, thefuck, nmap
- gparted and deja-dup
- Flatpaks are installed automatically by a daily `flatpak-sync` timer
  - all variants: `system_files/shared/etc/flatpak-sync/apps.txt`
  - bluefin only: `system_files/bluefin/etc/flatpak-sync/apps-bluefin.txt`
- `brew-sync` user timer that installs everything from `~/.config/Brewfile`
- ROCm packages are removed to save space

---

## Installation

1. Install any bootc based system (e.g. Bluefin or Bazzite).
2. Switch to the variant you want:
   ```bash
   sudo bootc switch ghcr.io/lesekater/development-bluefin-image
   ```
3. Reboot.

Switching between variants works the same way, just use another image from the table above.

## Customizing

- Packages: `build_files/install-apps.sh`
- Other build steps: `build_files/build.sh`
- Files copied into the image: `system_files/shared/` for all variants, `system_files/<variant>/` for a single variant
- Variants and base images: matrix in `.github/workflows/build.yml`

## Building locally

Requires [just](https://just.systems) and podman (both are preinstalled on Universal Blue images).

```bash
just build-all      # all variants
just build-main     # main image
```

A single variant:
```bash
just build my-image-bazzite latest "ghcr.io/ublue-os/bazzite-nvidia:latest" "bazzite"
```

`just --list` shows all other commands (VM images, linting, ...).

## Credits

Based on the [ublue-os/image-template](https://github.com/ublue-os/image-template).
