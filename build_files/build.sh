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

log "Building main image"

log "Step 1 : Setting up image info metadata"
    /ctx/bld/steps/01-image-info.sh

log "Step 2: Manage native packages"
    /ctx/bld/steps/02-native-packages.sh

log "Step 3: Configure system"
    /ctx/bld/steps/03-system-config.sh

log "Step 4: Configure flatpak"
    /ctx/bld/steps/04-flatpak.sh