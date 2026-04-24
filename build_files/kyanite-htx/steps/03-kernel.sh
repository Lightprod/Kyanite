#!/bin/bash

# Based on:
#   -> https://github.com/ublue-os/bazzite/blob/main/build_files/install-kernel
#   -> https://github.com/jumpyvi/alchemist/blob/main/build_files/packages/kernel.sh

set -ouex pipefail

# ======================================================================================
# functions:

copr_kernel_install(){
    dnf5 copr enable -y "${COPR_REPO}"
    # dnf5 install --allowerasing -y --setopt=tsflags=noscripts "${COPR_PACKAGES[@]}"
    dnf5 install --allowerasing -y "${COPR_PACKAGES[@]}"

}

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
# Defining variables

#  Get all packages with kernel in the name:
mapfile -t KERNEL_PKGS < <( rpm -qa kernel* )

# Check if it works:
# for pkg in "${KERNEL_PKGS[@]}";do log "${pkg}"; done

CACHYOS_KERNEL_PACKAGES=(
    "kernel-cachyos" 
    "kernel-cachyos-devel-matched"
    "kernel-cachyos-devel"
    "kernel-cachyos-modules"
    "kernel-cachyos-core"
)

CACHYOS_KERNEL_ADDONS_PACKAGES=(
    "libcap-ng" 
    "libcap-ng-devel" 
    "bore-sysctl" 
    "cachyos-ksm-settings" 
    "procps-ng" 
    "procps-ng-devel" 
    "uksmd" 
    "libbpf" 
    "scx-scheds"
    "scx-tools"
    "scx-manager" 
    # "cachyos-settings"
)
# ======================================================================================
#  Pre-install configuration

    # Dracut bypass:
{ log "Bypassing darcut"; } 2> /dev/null

pushd /usr/lib/kernel/install.d
mv 05-rpmostree.install 05-rpmostree.install.bak
mv 50-dracut.install 50-dracut.install.bak
printf '%s\n' '#!/bin/sh' 'exit 0' > 05-rpmostree.install
printf '%s\n' '#!/bin/sh' 'exit 0' > 50-dracut.install
chmod +x  05-rpmostree.install 50-dracut.install
popd

# ======================================================================================
#  Delete Fedora's kernel and their modules

{ log "Deleting Fedora's kernel..."; } 2> /dev/null

    # Delete kernel pakages:
for pkg in "${KERNEL_PKGS[@]}";do 
    rpm --erase --nodeps "${pkg}"
done 

    # Remove version locks:
dnf5 versionlock delete "${KERNEL_PKGS[@]}"

    # Delete leftovers:
rm -rf /usr/lib/modules/*
rm -rf /lib/modules/*

# ======================================================================================
#  Enable CachyOS's kernel COPR and install the kernel

COPR_REPO="bieszczaders/kernel-cachyos"
COPR_PACKAGES=("${CACHYOS_KERNEL_PACKAGES[@]}")

{ log "Enabling CachyOS's kernel COPR and installing the kernel..."; } 2> /dev/null

copr_kernel_install

# ======================================================================================
#  Enable CachyOS's kernel utilities COPR and install them

COPR_REPO="bieszczaders/kernel-cachyos-addons"
COPR_PACKAGES=("${CACHYOS_KERNEL_ADDONS_PACKAGES[@]}")

{ log "Enabling CachyOS's kernel addon COPR and installing the kernel..."; } 2> /dev/null

copr_kernel_install

dnf5 swap -y zram-generator-defaults cachyos-settings

# ======================================================================================
#  Post install Kernel configuration

{ log "Running post install kernel configuration..."

    # Get CachyOS's kernel version:
KERNEL_VERSION="$(rpm -q --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n' kernel-cachyos)"; } 2> /dev/null

    # Generate modules:
depmod -a "${KERNEL_VERSION}"

    # Copy vmlinuz
VMLINUZ_SOURCE="/usr/lib/kernel/vmlinuz-${KERNEL_VERSION}"
VMLINUZ_TARGET="/usr/lib/modules/${KERNEL_VERSION}/vmlinuz"
if [[ -f "${VMLINUZ_SOURCE}" ]]; then
    cp "${VMLINUZ_SOURCE}" "${VMLINUZ_TARGET}"
fi

    # Lock kernel packages:
dnf5 versionlock add "kernel-cachyos-${KERNEL_VERSION}"
dnf5 versionlock add "kernel-cachyos-modules-${KERNEL_VERSION}"


# ======================================================================================
#  Secure Boot configuration (Maybe later)


# ======================================================================================
#  Post install configuration

    # Reversing Dracut bypass:
{ log "Reversing dracut bypass"; } 2> /dev/null

pushd /usr/lib/kernel/install.d
mv -f 05-rpmostree.install.bak 05-rpmostree.install
mv -f 50-dracut.install.bak 50-dracut.install
popd

{ log "Rebuilding initramfs..."; } 2> /dev/null

export DRACUT_NO_XATTR=1
/usr/bin/dracut --no-hostonly \
--kver "${KERNEL_VERSION}" \
--reproducible -v --add ostree \
-f "/lib/modules/${KERNEL_VERSION}/initramfs.img"

chmod 0600 "/lib/modules/${KERNEL_VERSION}/initramfs.img"

{ log "Done"; } 2> /dev/null
