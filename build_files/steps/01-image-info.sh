#!/bin/bash

# Based on the work done in Aurora and Bazzite

log() { # from AmyOS's build files
  echo "=== $* ==="
}

display() {
    echo ""
    echo "============= Content of $* ==============="
    cat $*
    echo "==========================================
    "
}

set -ouex pipefail

# Available flavors for Kyanite:
# Main:
# main (main image, uses ublue's Kinoite image as base. Ref: docker://ghcr.io/lightprod/kyanite)
# main-bsx (main image with Plasma BigScreen experience. Plasma unstable  is required to install 'plasma-bigscreen', uses ublue's Kinoite image as base. Ref: docker://ghcr.io/lightprod/kyanite-bsx)

# Nvidia:
# main-nvidia (main image with nvidia drivers, uses ublue's Kinoite image as base. Ref: docker://ghcr.io/lightprod/kyanite-nvidia) <- Maybe later
# main-bsx-nvidia (main image with Plasma BigScreen experience and nvidia drivers, uses ublue's Kinoite image as base. Ref: docker://ghcr.io/lightprod/kyanite-nvidia) <- Maybe later

# Defining variables

# Non metadata:

IMAGE_INFO="/usr/share/ublue-os/image-info.json"
OS_RELEASE_FILE="/usr/lib/os-release"
OS_ID=kyanite
OS_NAME="${OS_ID^}"
OS_NAME_PRETTY="${OS_ID}"


# Common metadata for all flavors

IMAGE_VENDOR="lightprod"
CPE_NAME="cpe:/o:${IMAGE_VENDOR}:${OS_NAME_PRETTY}:${FEDORA_VERSION}"
DEFAULT_HOSTNAME="${OS_NAME_PRETTY}"
HOME_URL="https://github.com/Lightprod/Kyanite"
SUPPORT_URL="https://github.com/Lightprod/Kyanite/issues"
BUG_SUPPORT_URL="https://github.com/Lightprod/Kyanite/issues"
BOOTLOADER_NAME="${OS_NAME} ${FEDORA_VERSION}"


# DOCUMENTATION_URL="https://docs.bazzite.gg"
# LOGO_ICON="bazzite-logo-icon"
# LOGO_COLOR="0;38;2;138;43;226"
# IMAGE_BRANCH_NORMALIZED=$IMAGE_BRANCH
# IMAGE_TAG="${FEDORA_VERSION}"

define_image_metadata(){
#   # Flavor metadata
#     case "${IMAGE_FLAVOR}" in
#       "main")
#         log "Image flavor is main."

        IMAGE_NAME="${OS_NAME_PRETTY}"
        VARIANT="${OS_NAME}"
        VARIANT_ID="${OS_NAME_PRETTY}"

      # ;;
      # "main-bsx")
      #   log "Image flavor is main-bsx."

      #   IMAGE_NAME="${OS_NAME_PRETTY}-bsx"
      #   VARIANT="Big Screen"
      #   VARIANT_ID="bsx"

      # ;;
      # "main-nvidia")
      #   log "Image flavor is main-nvidia."

      #   IMAGE_NAME="${OS_NAME_PRETTY}-nvidia"
      #   VARIANT="${OS_NAME}"
      #   VARIANT_ID="nvidia"

      # ;;
      # "main-bsx-nvidia")
      #   log "Image flavor is main-nvidia."

      #   IMAGE_NAME="${OS_NAME_PRETTY}-bsx-nvidia"
      #   VARIANT="Big Screen"
      #   VARIANT_ID="bsx-nvidia"
      # ;;
    #   *)
    #     log "Image flavor not found. Aborting!"
    #     exit 1
    #   ;;
    # esac


IMAGE_REF="ostree-image-signed:docker://ghcr.io/$IMAGE_VENDOR/$IMAGE_NAME"
# VERSION="${IMAGE_VERSION} (${VARIANT})" # <= Need to get build nb from the action

}


log "Defining image metadata"
define_image_metadata


log "Setting up image info file"

cat > $IMAGE_INFO <<EOF
{
  "image-name": "$IMAGE_NAME",
  "image-flavor": "$IMAGE_FLAVOR",
  "image-vendor": "$IMAGE_VENDOR",
  "image-ref": "$IMAGE_REF",
  "image-tag": "$IMAGE_TAG",
  "base-image-name": "$BASE_IMAGE_NAME",
  "fedora-version": "$FEDORA_VERSION",

}
EOF

  # "image-branch": "$IMAGE_BRANCH_NORMALIZED",
  # "version": "$VERSION_TAG",
  # "version-pretty": "$VERSION_PRETTY"

log "Setting up os Release file"

sed -i "s|^NAME=.*|NAME=\"${OS_NAME}\"|" "${OS_RELEASE_FILE}"
# sed -i "s/^VERSION=.*/VERSION=\"${VERSION}\"" "${OS_RELEASE_FILE}"
# sed -i "s/^VERSION_CODENAME=.*/VERSION_CODENAME=\"\"" "${OS_RELEASE_FILE}"
# sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME='"'${OS_NAME} # Might not change it due to Steam Hardware Survey
sed -i "/^ID=.*/d" "${OS_RELEASE_FILE}"
sed -i "4iID=${OS_ID}" "${OS_RELEASE_FILE}"
sed -i "5iID_LIKE=fedora" "${OS_RELEASE_FILE}"
sed -i "s|^CPE_NAME=.*|CPE_NAME=\"${CPE_NAME}\"|" "${OS_RELEASE_FILE}"
sed -i "s/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME=\"${DEFAULT_HOSTNAME}\"/" "${OS_RELEASE_FILE}"
sed -i "s|^HOME_URL=.*|HOME_URL=\"${HOME_URL}\"|" "${OS_RELEASE_FILE}"
sed -i "s|^SUPPORT_URL=.*|SUPPORT_URL=\"${SUPPORT_URL}\"|" "${OS_RELEASE_FILE}"
sed -i "s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"${BUG_SUPPORT_URL}\"|" "${OS_RELEASE_FILE}"
sed -i "s|^VARIANT=.*|VARIANT=\"${VARIANT}\"|" "${OS_RELEASE_FILE}"
sed -i "s|^VARIANT_ID=.*|VARIANT_ID=\"${VARIANT_ID}\"|" "${OS_RELEASE_FILE}"
# sed -i "s|^OSTREE_ID=.*/OSTREE_ID=\"${IMAGE_VERSION}\"/" $OS_RELEASE_FILE
# sed -i "s|^BUILD_ID=.*/BUILD_ID=\"${BUILD_ID}\"/" $OS_RELEASE_FILE
# sed -i "s|^IMAGE_ID=.*/IMAGE_ID=\"${IMAGE_NAME}\"/" "${OS_RELEASE_FILE}"
# sed -i "s|^IMAGE_VERSION=.*/IMAGE_VERSION=\"${IMAGE_VERSION}\" /" $OS_RELEASE_FILE
sed -i "/REDHAT_BUGZILLA_PRODUCT=.*/d" "${OS_RELEASE_FILE}"
sed -i "/REDHAT_BUGZILLA_PRODUCT_VERSION=.*/d" "${OS_RELEASE_FILE}"
sed -i "/REDHAT_SUPPORT_PRODUCT=.*/d" "${OS_RELEASE_FILE}"
sed -i "/REDHAT_SUPPORT_PRODUCT_VERSION=.*/d" "${OS_RELEASE_FILE}"
echo "BOOTLOADER_NAME=\"${BOOTLOADER_NAME}\"" >> "${OS_RELEASE_FILE}"

log "Fix issues caused by ID no longer being fedora"
sed -i "s/^EFIDIR=.*/EFIDIR=\"fedora\"/" /usr/sbin/grub2-switch-to-blscfg

log "Done."

display $IMAGE_INFO
display $OS_RELEASE_FILE

# Note: Rebuild initramfs


# sed -i "s/^VARIANT_ID=.*/VARIANT_ID=$IMAGE_NAME/" /usr/lib/os-release
# sed -i "s/^PRETTY_NAME=.*/PRETTY_NAME=\"$OS_NAME\"/" /usr/lib/os-release
# sed -i "s/^NAME=.*/NAME=\"$IMAGE_PRETTY_NAME\"/" /usr/lib/os-release
# sed -i "s|^HOME_URL=.*|HOME_URL=\"$HOME_URL\"|" /usr/lib/os-release
# # sed -i "s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"$DOCUMENTATION_URL\"|" /usr/lib/os-release
# sed -i "s|^SUPPORT_URL=.*|SUPPORT_URL=\"$SUPPORT_URL\"|" /usr/lib/os-release
# sed -i "s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"$BUG_SUPPORT_URL\"|" /usr/lib/os-release
# # sed -i "s|^CPE_NAME=\"cpe:/o:fedoraproject:fedora|CPE_NAME=\"cpe:/o:universal-blue:${IMAGE_PRETTY_NAME,}|" /usr/lib/os-release
# sed -i "s/^DEFAULT_HOSTNAME=.*/DEFAULT_HOSTNAME=\"${DEFAULT_HOSTNAME,}\"/" /usr/lib/os-release
# sed -i "s/^ID=fedora/ID=${IMAGE_PRETTY_NAME,}\nID_LIKE=\"${IMAGE_LIKE}\"/" /usr/lib/os-release
# # sed -i "s/^LOGO=.*/LOGO=$LOGO_ICON/" /usr/lib/os-release
# # sed -i "s/^ANSI_COLOR=.*/ANSI_COLOR=\"$LOGO_COLOR\"/" /usr/lib/os-release
# sed -i "/^REDHAT_BUGZILLA_PRODUCT=/d; /^REDHAT_BUGZILLA_PRODUCT_VERSION=/d; /^REDHAT_SUPPORT_PRODUCT=/d; /^REDHAT_SUPPORT_PRODUCT_VERSION=/d" /usr/lib/os-release
# sed -i "s|^VERSION_CODENAME=.*|VERSION_CODENAME=\"${BASE_IMAGE_NAME^}\"|" /usr/lib/os-release

# echo "BUILD_ID=\"$VERSION_PRETTY\"" >> /usr/lib/os-release
# echo "BOOTLOADER_NAME=\"$IMAGE_PRETTY_NAME ($VERSION_PRETTY)\"" >> /usr/lib/os-release

