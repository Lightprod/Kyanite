#!/bin/bash
# shellcheck disable=SC2016
set -ouex pipefail

# ======================================================================================
# functions:

log() { # from AmyOS's build files
  { echo "=== $* ==="; } 2> /dev/null
}

display() {
    echo ""
    echo "============= Content of $* ==============="
    cat "$*"
    echo "==========================================
    "
}

# ======================================================================================
# Variables:

KYANITE_JUST_CONFIG=$(< /usr/share/kyanite/just/justfile)
FLATPAK_PREINSTALL_FOLDER="/usr/share/flatpak/preinstall.d"
FLATPAK_PREINSTALL_FILES_LIST=($(ls "${FLATPAK_PREINSTALL_FOLDER}"))
PREINSTALL_LIST_FILE="/usr/share/kyanite/flatpak/preinstall"

# ======================================================================================
# Enable systemd services

# { log "Enabling plasmalogin service..."; } 2> /dev/null

# systemctl enable plasmalogin.service

# { log "Enabling plasmasetup service..."; } 2> /dev/null

# systemctl enable plasma-setup.service

{ log "Enabling cockpit service..."; } 2> /dev/null

systemctl enable cockpit.socket

{ log "Enabling sshd service..."; } 2> /dev/null

systemctl enable sshd.service

{ log "Enabling Kyanite's flatpak manager service..."; } 2> /dev/null

systemctl enable kyanite-flatpak-manager.service

# { log "Enabling kde connect user service..."; } 2> /dev/null

# systemctl --user enable kde-connect.service

# ======================================================================================
# Diverse fix

{ log "Fix scripts permissions..."; } 2> /dev/null

cd /usr/libexec/kyanite
chmod +x flatpak-manager

# ======================================================================================
# Amending existing just config

{ log "Adding Kyanite's justfile to existing config..."; } 2> /dev/null

cd /usr/share/ublue-os

sed -i "11i${KYANITE_JUST_CONFIG}" justfile

# ======================================================================================
# Generate readable flatpak preinstall list

{ log "Generate a readable list of preinstalled flatpaks..."; } 2> /dev/null

cd "${FLATPAK_PREINSTALL_FOLDER}"
touch "${PREINSTALL_LIST_FILE}"

for flatpak in "${FLATPAK_PREINSTALL_FILES_LIST[@]}"; do
    FLATPAK_NAME=$(echo "${flatpak}" | cut -d. -f 1)
    FLATPAK_ID=$(cat "${flatpak}" | grep -P "Flatpak Preinstall *" )
    FLATPAK_ID=$(echo "${FLATPAK_ID}" | cut -d ' ' -f 3 | cut -d] -f -1 )
    echo "${FLATPAK_NAME^} (${FLATPAK_ID})" >> "${PREINSTALL_LIST_FILE}"
done


# ======================================================================================
# Amending default bashrc config

{ log "Amending default bashrc..."; } 2> /dev/null

cd /etc/skel

echo 'eval "$(atuin init bash)"' >> ./bashrc
echo 'eval "$(starship init bash)"' >> ./bashrc

{ log "Done"; } 2> /dev/null