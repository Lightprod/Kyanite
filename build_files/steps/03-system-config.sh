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
SCRIPT_FOLDER=/usr/libexec/kyanite

# ====================================================================
# Add init scripts

log "Add starship init script to bash"

echo 'eval "$(starship init bash)"' >> $DEFAULT_BASHRC_FILE

log "Add atuin init script to bash"

echo 'eval "$(atuin init bash)"' >> $DEFAULT_BASHRC_FILE


# ====================================================================
# Copied scripts can't be executed, this fix it

log "Fix scripts not being executable"

cd ${SCRIPT_FOLDER}
chmod +x *



# ====================================================================
#  Enable new systemd services

log "Enabling setup service"
systemctl enable kyanite-setup
