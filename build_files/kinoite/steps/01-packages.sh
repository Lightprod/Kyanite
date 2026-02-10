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


# Defining variables

REMOVE_PACKAGES=(
    "ublue-os-update-services"
    "plasma-welcome-fedora"
)

ADD_PACKAGES=(
    "plasma-discover-rpm-ostree"
)
# ====================================================================
# Remove packages

dnf remove -y ${REMOVE_PACKAGES[@]}

# ====================================================================
# Add removed packages

    dnf install --skip-broken --skip-unavailable -y ${ADD_PACKAGES[@]}





