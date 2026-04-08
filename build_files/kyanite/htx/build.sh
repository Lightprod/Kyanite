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

log "Building home theater image"

log "Step 1 : Setting up image metadata"
    /ctx/bld/kyanite/htx/steps/01-image-metadata.sh

log "Step 2 : Managing packages"
    /ctx/bld/kyanite/htx/steps/01-image-metadata.sh

log "Step 4 : Configuring Flatpak"
    /ctx/bld/kyanite/htx/steps/01-image-metadata.sh

log "Final step: Cleanup build"
    /ctx/bld/common/cleanup.sh
