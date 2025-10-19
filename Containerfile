# Build arguments for base image selection
ARG BASE_IMAGE=ghcr.io/ublue-os/bluefin-dx:stable

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image - Configurable via build args
FROM $BASE_IMAGE

# Supports multiple variants via BASE_IMAGE build argument
# See VARIANTS.md for available options

# Install customizations via build scripts

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/install-apps.sh && \
    /ctx/build.sh && \
    ostree container commit
    
# Verify final image
RUN bootc container lint
