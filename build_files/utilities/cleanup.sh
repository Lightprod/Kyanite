#!/bin/bash
set -ouex pipefail

# ======================================================================================
# functions:

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

# ================================================================================

{ log "Clean up dnf"; } 2> /dev/null

dnf5 clean all

{ log "Clean up temporary files"; } 2> /dev/null

rm -rf /tmp/*
rm -rf /var/tmp/*
# rm -rf /usr/etc