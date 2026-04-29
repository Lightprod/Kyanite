#!/bin/bash

set -ouex pipefail

# ======================================================================================
# functions:

log() { # from AmyOS's build files
  { echo "=== $* ==="; } 2> /dev/null
}

# display() {
#     echo ""
#     echo "============= Content of $* ==============="
#     cat "$*"
#     echo "==========================================
#     "
# }


# ======================================================================================
# Variables:

    # System:
CURRENT_DATE=$(printf '%(%Y%m%d)T\n' -1)
IMAGE_BUILD_VER="${FEDORA_VERSION}.${CURRENT_DATE}"

    # Files:
IMAGE_INFO_FILE="/usr/share/ublue-os/image-info.json"
OS_RELEASE_FILE="/usr/lib/os-release"

    # Operating System:
OS_ID="kyanite"
OS_NAME="${OS_ID^}"
# OS_NAME_PRETTY="${OS_ID}"

    # Image:
IMAGE_NAME="${OS_ID}"
IMAGE_FLAVOR="htx"
IMAGE_FLAVOR_PRETTY="Home Theater Experience"
IMAGE_VENDOR="lightprod"
IMAGE_TAG="unstable"
BASE_IMAGE_NAME="kinoite"
CPE_NAME="cpe:/o:${IMAGE_VENDOR}:${OS_ID}:${FEDORA_VERSION}"

    # Repository:
IMAGE_REF="ostree-image-signed:docker://ghcr.io/$IMAGE_VENDOR/$IMAGE_NAME"
DEFAULT_HOSTNAME="${OS_ID}"
HOME_URL="https://github.com/Lightprod/Kyanite"
SUPPORT_URL="https://github.com/Lightprod/Kyanite/issues"


BOOTLOADER_NAME="${OS_NAME} ${FEDORA_VERSION} (build-${IMAGE_BUILD_VER})"

    # Unused:
# DOCUMENTATION_URL="https://docs.bazzite.gg"
# LOGO_ICON="bazzite-logo-icon"
# LOGO_COLOR="0;38;2;138;43;226"
# IMAGE_BRANCH_NORMALIZED=$IMAGE_BRANCH


# ======================================================================================

{ log "Populating image-info"; } 2> /dev/null

cat > $IMAGE_INFO_FILE <<EOF
{
  "image-name": "$IMAGE_NAME",
  "image-build": "$IMAGE_BUILD_VER",
  "image-flavor": "$IMAGE_FLAVOR",
  "image-flavor-name:" "$IMAGE_FLAVOR_PRETTY",
  "image-vendor": "$IMAGE_VENDOR",
  "image-ref": "$IMAGE_REF",
  "image-tag": "$IMAGE_TAG",
  "base-image-name": "$BASE_IMAGE_NAME",
  "fedora-version": "$FEDORA_VERSION",
}
EOF

{ log "Populating os-release"; } 2> /dev/null

sed -i "s|^NAME=.*|NAME=\"${OS_NAME}\"|" "${OS_RELEASE_FILE}"
sed -i "s|^VERSION=.*|VERSION=\"${FEDORA_VERSION}\"|" "${OS_RELEASE_FILE}"
sed -i "s|^CPE_NAME=.*|CPE_NAME=\"${CPE_NAME}\"|" "${OS_RELEASE_FILE}"
sed -i "s/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME=\"${DEFAULT_HOSTNAME}\"/" "${OS_RELEASE_FILE}"
sed -i "s|^HOME_URL=.*|HOME_URL=\"${HOME_URL}\"|" "${OS_RELEASE_FILE}"
sed -i "s|^SUPPORT_URL=.*|SUPPORT_URL=\"${SUPPORT_URL}\"|" "${OS_RELEASE_FILE}"
sed -i "/DOCUMENTATION_URL=.*/d" "${OS_RELEASE_FILE}"
sed -i "s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"${SUPPORT_URL}\"|" "${OS_RELEASE_FILE}"
sed -i "s|^VARIANT=.*|VARIANT=\"${IMAGE_FLAVOR_PRETTY}\"|" "${OS_RELEASE_FILE}"
sed -i "s|^VARIANT_ID=.*|VARIANT_ID=\"${IMAGE_FLAVOR}\"|" "${OS_RELEASE_FILE}"
sed -i "s|^BUILD_ID=.*|BUILD_ID=\"${IMAGE_BUILD_VER}\"|" $OS_RELEASE_FILE
sed -i "/REDHAT_BUGZILLA_PRODUCT=.*/d" "${OS_RELEASE_FILE}"
sed -i "/REDHAT_BUGZILLA_PRODUCT_VERSION=.*/d" "${OS_RELEASE_FILE}"
sed -i "/REDHAT_SUPPORT_PRODUCT=.*/d" "${OS_RELEASE_FILE}"
sed -i "/REDHAT_SUPPORT_PRODUCT_VERSION=.*/d" "${OS_RELEASE_FILE}"
echo "BOOTLOADER_NAME=\"${BOOTLOADER_NAME}\"" >> "${OS_RELEASE_FILE}"

{ log "Done"; } 2> /dev/null