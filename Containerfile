##########################################
#   ARGUMENTS AND PREBUILDS OPERATIONS   #
##########################################

ARG FEDORA_VERSION="43"
ARG IMAGE_VERSION="43.20260212"
# ARG IMAGE_FLAVOR="main"

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /bld


##########################################
#           CLEAN UPSTREAM IMAGE         #
##########################################

FROM ghcr.io/ublue-os/kinoite-main:${FEDORA_VERSION} AS kinoite

ARG FEDORA_VERSION

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/bld/kinoite/build.sh 


##########################################
#               BASE IMAGE               #
##########################################

FROM kinoite AS kyanite_base

ARG FEDORA_VERSION
ARG IMAGE_VERSION
ARG IMAGE_FLAVOR="base"

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/bld/kyanite/base/build.sh 


##########################################
#           HOME THEATER IMAGE           #
##########################################

FROM kyanite_base AS kyanite_htx

ARG FEDORA_VERSION
ARG IMAGE_VERSION

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/bld/kyanite/htx/build.sh 

##########################################
#         VERIFY FILE AND COMMIT         #
##########################################

RUN ostree container commit
RUN bootc container lint


# # Allow build scripts to be referenced without being copied into the final image
# FROM scratch AS ctx
# COPY build_files /

# # Base Image
# FROM ghcr.io/ublue-os/bazzite:stable

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

# RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
#     --mount=type=cache,dst=/var/cache \
#     --mount=type=cache,dst=/var/log \
#     --mount=type=tmpfs,dst=/tmp \
#     /ctx/build.sh
    
### LINTING
## Verify final image and contents are correct.
# RUN bootc container lint
