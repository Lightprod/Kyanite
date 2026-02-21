#!/bin/bash

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

# ======================================================================================
# Defining variables

KERNEL_PACKAGES=(
    "kernel" 
    "kernel-core" 
    "kernel-modules" 
    "kernel-modules-core" 
    "kernel-modules-extra"
)


# ======================================================================================
#  Bypass kernel install darcut trigger
#  based on : https://github.com/ublue-os/bazzite/blob/2f54d203f7f60a6d68fad4c7f2212fa26a5ee452/build_files/install-kernel#L8-L16
#  and : https://github.com/ublue-os/bazzite/blob/2f54d203f7f60a6d68fad4c7f2212fa26a5ee452/build_files/install-kernel#L52-L55

log "Bypassing darcut"

pushd /usr/lib/kernel/install.d
mv 05-rpmostree.install 05-rpmostree.install.bak
mv 50-dracut.install 50-dracut.install.bak
printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install
chmod +x  05-rpmostree.install 50-dracut.install
popd

# ======================================================================================
#  Swap Fedora kernel for CachyOS kernel

log "Activating CachyOS Kernel COPR..."
    dnf copr enable bieszczaders/kernel-cachyos -y
    # dnf copr enable bieszczaders/kernel-cachyos-addons

log "Removing Fedora's kernel and installing CachyOS's kernel"
    # dnf swap --skip-broken --skip-unavailable -y --repo=copr:copr.fedorainfracloud.org:bieszczaders/kernel-cachyos
    dnf remove -y remove ${KERNEL_PACKAGES[@]}
    dnf install --skip-broken --skip-unavailable -y kernel-cachyos-devel-matched

# Setup SELinux for loading kernel modules
    setsebool -P domain_kernel_load_modules on

# ======================================================================================
#  Reversing dracut bypass
#  based on : https://github.com/ublue-os/bazzite/blob/2f54d203f7f60a6d68fad4c7f2212fa26a5ee452/build_files/install-kernel#L52-L55

log "Reversing dracut bypass"

pushd /usr/lib/kernel/install.d
mv -f 05-rpmostree.install.bak 05-rpmostree.install
mv -f 50-dracut.install.bak 50-dracut.install
popd

log "Rebuilding initramfs..."
   /ctx/bld/common/initramfs.sh

log "Done."