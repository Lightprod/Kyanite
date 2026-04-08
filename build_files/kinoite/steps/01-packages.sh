#!/bin/bash

log() { # from AmyOS's build files
  echo "=== $* ==="
}

display() {
    echo ""
    echo "============= Content of $* ==============="
    cat "$*"
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

dnf5 remove -y "${REMOVE_PACKAGES[@]}"

# ====================================================================
# Add removed packages

dnf5 install -y "${ADD_PACKAGES[@]}"





