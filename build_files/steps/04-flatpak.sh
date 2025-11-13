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

log "Defining variables"

WORK_FOLDER=/tmp/flatpak
CONFIG_FOLDER=/usr/share/kyanite/flatpak
DEFAULT_FLATPAKS_CONFIG_FILE=/usr/share/kyanite/flatpak/default_list

GIT_UPSTREAM_FLATPAKS=/ctx/ref/main/flatpak/upstream_default
GIT_DEFAULT_FLATPAKS=/ctx/ref/main/flatpak/kyanite_default

UPSTREAM_FLATPAKS=/tmp/flatpak/upstream_default
DEFAULT_FLATPAKS=/tmp/flatpak/kyanite_default




# ================================================================================

log "Creating work folder..."

mkdir ${WORK_FOLDER}
cd ${WORK_FOLDER}

# ================================================================================

log "Copying reference files to work folder..."

cp ${GIT_UPSTREAM_FLATPAKS} upstream_default
cp ${GIT_DEFAULT_FLATPAKS} kyanite_default

# ================================================================================

log "Creating default flatpak list..."

touch default_list
cat ${UPSTREAM_FLATPAKS} >> default_list
cat ${DEFAULT_FLATPAKS} >> default_list

display default_list

# ================================================================================
log "Copying default list to the image"
cp default_list ${DEFAULT_FLATPAKS_CONFIG_FILE}


log "Done"


