# Image Variants

This repository builds three variants of the custom Universal Blue image, each optimized for different use cases:

## Quick Comparison

| Variant | Base Image | GPU Support | Target Use Case | Published As |
|---------|------------|-------------|-----------------|--------------|
| **Main Image** (default) | `bluefin-dx-nvidia:stable` | NVIDIA GPUs | Workstations, ML/AI | `<repo>` |
| **Bluefin** | `bluefin-dx-nvidia:stable` | NVIDIA GPUs | Workstations, ML/AI | `<repo>-bluefin` |
| **Bluefin Laptop** | `bluefin-dx:stable` | Integrated Graphics | Laptops, battery life | `<repo>-bluefin-laptop` |
| **Bazzite** | `bazzite-nvidia:latest` | NVIDIA GPUs | Gaming, entertainment | `<repo>-bazzite` |

> **Note:** The Main Image and Bluefin variant are identical - the Main Image is automatically published without suffix for convenience.

## Main Image (Default)

**Base Image:** `ghcr.io/ublue-os/bluefin-dx-nvidia:stable`  
**Target Audience:** Developers and content creators with NVIDIA GPUs  
**Published as:** `ghcr.io/<username>/<repo-name>` (same as Bluefin variant)

### Features
- **Developer Experience (DX)**: Pre-configured development environment with popular tools
- **NVIDIA Support**: Full NVIDIA driver support for GPU acceleration
- **Container Development**: Podman, Docker, and container development tools
- **IDE Support**: VS Code, development extensions, and language runtimes
- **Performance**: Optimized for development workloads with GPU acceleration

## Bluefin Variant

**Base Image:** `ghcr.io/ublue-os/bluefin-dx-nvidia:stable`  
**Target Audience:** Developers and content creators with NVIDIA GPUs  
**Published as:** `ghcr.io/<username>/<repo-name>-bluefin` (identical to Main Image)

This variant is built and published separately but contains the exact same content as the Main Image.


## Bluefin Laptop Variant

**Base Image:** `ghcr.io/ublue-os/bluefin-dx:stable`  
**Target Audience:** Laptop users and developers without dedicated GPUs  
**Published as:** `ghcr.io/<username>/<repo-name>-bluefin-laptop`

### Features
- **Developer Experience (DX)**: Pre-configured development environment with popular tools
- **Power Efficiency**: Optimized for battery life and integrated graphics
- **Container Development**: Podman, Docker, and container development tools
- **IDE Support**: VS Code, development extensions, and language runtimes
- **Lightweight**: No NVIDIA drivers for better compatibility with laptops


## Bazzite Variant

**Base Image:** `ghcr.io/ublue-os/bazzite-nvidia:latest`  
**Target Audience:** Gamers and entertainment enthusiasts with NVIDIA GPUs  
**Published as:** `ghcr.io/<username>/<repo-name>-bazzite`

### Features
- **Gaming Optimized**: Pre-configured for gaming with performance tweaks
- **Steam Deck Compatible**: Supports Steam Deck hardware and gaming modes
- **NVIDIA GPU Support**: Full NVIDIA driver support for gaming performance
- **Gaming Software**: Steam, Lutris, and gaming tools pre-installed
- **Media Center**: Optimized for entertainment and media consumption


## Switching Between Variants

You can switch between variants at any time using bootc:

```bash
# Switch to Main Image (recommended - same as bluefin variant)
sudo bootc switch ghcr.io/<username>/<repo-name>

# Switch to Bluefin variant (identical to main image)
sudo bootc switch ghcr.io/<username>/<repo-name>-bluefin

# Switch to Bluefin Laptop variant
sudo bootc switch ghcr.io/<username>/<repo-name>-bluefin-laptop

# Switch to Bazzite variant
sudo bootc switch ghcr.io/<username>/<repo-name>-bazzite
```

## Shared Customizations

All variants are built from the same Containerfile and share the same build scripts and customizations:
- `Containerfile` - Single file with `BASE_IMAGE` build argument for variant selection
- `build_files/build.sh` - Main customization script
- `build_files/install-apps.sh` - Application installation script

This ensures consistency across variants while maintaining the unique characteristics of each base image.


