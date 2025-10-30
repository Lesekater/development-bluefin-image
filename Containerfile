# Build arguments for base image selection
ARG BASE_IMAGE=ghcr.io/ublue-os/bluefin-dx:stable
ARG VARIANT_TYPE=bluefin

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image - Configurable via build args
FROM $BASE_IMAGE

# Make build arguments available as environment variables
ENV VARIANT_TYPE=${VARIANT_TYPE}

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

# Copy all shared system files into the image
COPY system_files/shared/ /

# Copy variant-specific system files into the image (optional)
# Fallback: copy whole system_files tree and only apply the variant if the folder exists
COPY system_files/ /tmp/system_files/
RUN if [ -d /tmp/system_files/${VARIANT_TYPE} ]; then cp -a /tmp/system_files/${VARIANT_TYPE}/ /; fi && \
    rm -rf /tmp/system_files

# Enable timer by default
RUN systemctl enable flatpak-sync.timer

# Verify final image
RUN bootc container lint
