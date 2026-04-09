##########################################
#   ARGUMENTS AND PREBUILDS OPERATIONS   #
##########################################

ARG FEDORA_VERSION="43"
ARG IMAGE_VERSION="43.20260408"

# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /bld

##########################################
#           HOME THEATER IMAGE           #
##########################################

FROM ghcr.io/ublue-os/kinoite-main:${FEDORA_VERSION} AS kyanite_htx

ARG FEDORA_VERSION
ARG IMAGE_VERSION
ARG IMAGE_FLAVOR="htx"

# COPY system_files/htx /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/bld/kyanite-htx/build.sh 

##########################################
#         VERIFY FILE AND COMMIT         #
##########################################

RUN bootc container lint