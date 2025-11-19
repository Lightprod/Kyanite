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

# ================================================================================

log "Clean up dnf"

dnf5 clean all

echo 'Clean up temporary files'

rm -rf /tmp/*
rm -rf /var/tmp/*
# rm -rf /usr/etc