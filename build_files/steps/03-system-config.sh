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

DEFAULT_BASHRC_FILE=/etc/skel/.bashrc


# ====================================================================
# Add init scripts

log "Add starship init script to bash"

echo 'eval "$(starship init bash)"' >> $DEFAULT_BASHRC_FILE

log "Add atuin init script to bash"

echo 'eval "$(atuin init bash)"' >> $DEFAULT_BASHRC_FILE

