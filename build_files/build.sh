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

log "Building $IMAGE_NAME"

log "Step 1 : Setting up image info metadata"
    /ctx/steps/01-image-info.sh

log "Step 2: Native packages management"
    /ctx/steps/02-native-packages.sh

log "Step 3: System configuration"
    /ctx/steps/03-system-config.sh