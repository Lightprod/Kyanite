#!/bin/bash
set -ouex pipefail

# From ublue's main image repo: https://github.com/ublue-os/main/blob/main/build_files/initramfs.sh

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
#  Post install configuration

    # Get CachyOS's kernel version:
KERNEL_VERSION="$(rpm -q --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n' kernel-cachyos)"

  # Rebuild initramfs:
{ log "Rebuilding initramfs..."; } 2> /dev/null

export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly \
--kver "${KERNEL_VERSION}" \
--reproducible -v --add ostree \
-f "/lib/modules/${KERNEL_VERSION}/initramfs.img"

chmod 0600 "/lib/modules/${KERNEL_VERSION}/initramfs.img"

{ log "Done"; } 2> /dev/null