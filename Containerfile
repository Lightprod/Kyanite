# From Aurora
ARG BASE_IMAGE_NAME="kinoite-main"
ARG FEDORA_VERSION="42"
ARG BASE_IMAGE="ghcr.io/ublue-os/${BASE_IMAGE_NAME}"
ARG IMAGE_FLAVOR="main"
ARG IMAGE_TAG="${tag}"

# ARG IMAGE_NAME="${image_name}"
# ARG IMAGE_VENDOR="lightprod"


# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /


##########################################
#             MAIN IMAGE
##########################################

# # From bazzite
# ARG IMAGE_NAME="${IMAGE_NAME:-kyanite}"
# ARG IMAGE_VENDOR="${IMAGE_VENDOR:-lightprod}"
# ARG IMAGE_FLAVOR="${IMAGE_FLAVOR:-main}"
# # ARG NVIDIA_FLAVOR="${NVIDIA_FLAVOR:-nvidia}"
# # ARG NVIDIA_BASE="${NVIDIA_BASE:-bazzite}"
# # ARG KERNEL_FLAVOR="${KERNEL_FLAVOR:-bazzite}"
# # ARG KERNEL_VERSION="${KERNEL_VERSION:-6.16.4-102.bazzite.fc42.x86_64}"
# ARG IMAGE_BRANCH="${IMAGE_BRANCH:-main}"
# ARG BASE_IMAGE_NAME="${BASE_IMAGE_NAME:-kinoite}"
# ARG FEDORA_VERSION="${FEDORA_VERSION:-42}"
# # ARG JUPITER_FIRMWARE_VERSION="${JUPITER_FIRMWARE_VERSION:-jupiter-20241205.1}"
# ARG SHA_HEAD_SHORT="${SHA_HEAD_SHORT}"
# ARG VERSION_TAG="${VERSION_TAG}"
# ARG VERSION_PRETTY="${VERSION_PRETTY}"


FROM ${BASE_IMAGE}:${FEDORA_VERSION} AS ${IMAGE_NAME}

# ARG BASE_IMAGE_NAME="kionite-main"
# ARG FEDORA_VERSION="42"
# ARG BASE_IMAGE="ghcr.io/ublue-os/${BASE_IMAGE_NAME}"
# ARG IMAGE_TAG="${tag}"

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh    

    ### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
