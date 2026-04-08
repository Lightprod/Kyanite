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

log "Cleaning upstream image"

log "Step 1 : Cleanup packages"
    /ctx/bld/kinoite/steps/01-packages.sh

# log "Step 2 : Cleanup system configs"
#     /ctx/bld/kinoite/steps/02-system-config.sh

log "Cleanup build"
    /ctx/bld/common/cleanup.sh

log "Done."