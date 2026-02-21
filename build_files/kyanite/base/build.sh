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

log "Building common image"

log "Step 1 : Install common packages"
    /ctx/bld/kyanite/base/steps/01-packages.sh

log "Step 2 : Install CachyOS's kernel"
    /ctx/bld/kyanite/base/steps/02-kernel.sh

log "Step 3 : Configuring system"
    /ctx/bld/kyanite/base/steps/01-image-metadata.sh

log "Cleanup build"
    /ctx/bld/common/cleanup.sh
