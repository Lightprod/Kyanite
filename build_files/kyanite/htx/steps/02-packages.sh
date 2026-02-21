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

REMOVE_PACKAGES=(
    "kate"
    "nvtop"
)

ADD_PACKAGES_FEDORA_REPO=(
   
)

EXCLUDED_PACKAGE_FEDORA_REPO=""

ADD_PACKAGES_RPMFUSION_REPO=(

)

EXCLUDED_PACKAGE_RPMFUSION_REPO=""

# ======================================================================================
#  Remove uneeded packages from the base image

log "Removing packages..."
    dnf remove -y ${REMOVE_PACKAGES[@]}


# ======================================================================================
#  Install packages from fedora repos

# log "Installing packages from fedora repos..."
    # dnf install --skip-broken --skip-unavailable --exclude=${EXCLUDED_PACKAGE_FEDORA_REPO} -y ${ADD_PACKAGES_FEDORA_REPO[@]}

# ======================================================================================
#  Install packages from rpm-fusion repos

# log "Installing packages from rpm-fusion..."
    # dnf install --skip-broken --skip-unavailable -y --repo="rpmfusion*" ${ADD_PACKAGES_RPMFUSION_REPO}
    # dnf install --skip-broken --skip-unavailable -y --exclude=${EXCLUDED_PACKAGE_RPMFUSION_REPO} ${ADD_PACKAGES_RPMFUSION_REPO[@]}

# ======================================================================================

