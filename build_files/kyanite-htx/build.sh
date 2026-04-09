#!/bin/bash
set -ouex pipefail

# ======================================================================================
# functions:

log() { # Modified from AmyOS's build files
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

{ log "Building kyanite-htx..."; } 2> /dev/null

# { log "Step 1 : Setting up image metadata"; } 2> /dev/null
    # /ctx/bld/kyanite/htx/steps/01-image-metadata.sh

# { log "Step 2 : Managing packages"; } 2> /dev/null
    # /ctx/bld/kyanite-htx/steps/02-packages.sh

{ log "Step 3 : Swapping Kernel"; } 2> /dev/null
    /ctx/bld/kyanite-htx/steps/03-kernel.sh

{ log "Final step: Cleanup build"; } 2> /dev/null
    /ctx/bld/utilities/cleanup.sh

