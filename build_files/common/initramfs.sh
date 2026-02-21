#!/bin/bash
# From ublue's main image repo: https://github.com/ublue-os/main/blob/main/build_files/initramfs.sh
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

# ================================================================================
# log "Rebuilding initramfs..."

KERNEL_VERSION="$(rpm -q --queryformat="%{evr}.%{arch}" kernel-cachyos-devel-matched)"

# Ensure Initramfs is generated
export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly --kver "${KERNEL_VERSION}" --reproducible -v --add ostree -f "/lib/modules/${KERNEL_VERSION}/initramfs.img"
chmod 0600 "/lib/modules/${KERNEL_VERSION}/initramfs.img"