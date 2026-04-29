#!/bin/bash

set -ouex pipefail

# ======================================================================================
# functions:

copr_update(){
    COPR_REPO_ID="copr:copr.fedorainfracloud.org:${COPR_REPO////:}"
    dnf5 copr enable -y "${COPR_REPO}"
    dnf5 config-manager setopt "${COPR_REPO_ID}.priority=1"
    dnf5 update -y --repo="${COPR_REPO_ID}" --allowerasing
    dnf5 config-manager setopt "${COPR_REPO_ID}.priority=99"
}

copr_install(){
    COPR_REPO_ID="copr:copr.fedorainfracloud.org:${COPR_REPO////:}"
    dnf5 copr enable -y "${COPR_REPO}"
    dnf5 config-manager setopt "${COPR_REPO_ID}.priority=1"
    dnf5 install -y "${COPR_PACKAGES[@]}"
    dnf5 config-manager setopt "${COPR_REPO_ID}.priority=99"
}

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


# ======================================================================================
# Defining variables

REMOVE_UPSTREAM_PACKAGES=(
    "ublue-os-update-services"
    "krfb"
    # "sddm"
)

COCKPIT_PACKAGES_FEDORA_REPO=(
    "cockpit"
    "cockpit-files"
    "cockpit-bridge"
	"cockpit-networkmanager"
	"cockpit-selinux"
	"cockpit-storaged"
	"cockpit-system"
)

EXCLUDED_COCKPIT_PACKAGES="cockpit-ostree,cockpit-podman,cockpit-packagekit"


SYSTEM_PACKAGES_FEDORA_REPO=(
    "fastfetch"
    "gvfs"
    "gvfs-smb"
    "gvfs-fuse"
    "gum"
    "mc"
    "atuin"
    "gparted"
)

KDE_PACKAGES_FEDORA_REPO=(
    # "plasma-login-manager" # Exist in F44
    "plasma-bigscreen"
    # "plasma-setup" # Exist in F44
)

SYSTEM_PACKAGES_TERRA_REPO=(
    "firacode-nerd-fonts"
    "starship"
)

STEAM_PACKAGES_TERRA_REPO=(
    "steam"
    "steam-devices"
)

EXCLUDED_STEAM_PACKAGES="gamemode"

UBLUE_COPR_PACKAGES=(
    "ublue-fastfetch"
	"ublue-motd"
    "ublue-os-just"
)

EXTERNAL_PACKAGES=(
    "firefoxpwa"
)

# ======================================================================================
#  Enable fedora-multimedia repo

{ log "Enabling fedora-multimedia..."; } 2> /dev/null

dnf5 -y config-manager setopt fedora-multimedia.enabled=1

# ======================================================================================
#  Remove uneeded packages from upstream

{ log "Removing packages..."; } 2> /dev/null

dnf5 remove -y "${REMOVE_UPSTREAM_PACKAGES[@]}"

# ======================================================================================
#  Install cockpit from Fedora repos

{ log "Installing Cockpit..."; } 2> /dev/null

# dnf5 --setopt=tsflags=noscripts install --exclude=${EXCLUDED_COCKPIT_PACKAGES} -y "${COCKPIT_PACKAGES_FEDORA_REPO[@]}"
dnf5 install --exclude=${EXCLUDED_COCKPIT_PACKAGES} -y "${COCKPIT_PACKAGES_FEDORA_REPO[@]}"

# ======================================================================================
#  Install packages from Fedora repos

{ log "Installing system packages..."; } 2> /dev/null

dnf5 install -y "${SYSTEM_PACKAGES_FEDORA_REPO[@]}"

# ======================================================================================
#  Install KDE packages from Fedora repos

{ log "Installing KDE packages..."; } 2> /dev/null

dnf5 install -y "${KDE_PACKAGES_FEDORA_REPO[@]}"

# ======================================================================================
#  Install Terra repo

{ log "Installing Terra repo..."; } 2> /dev/null

dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# ======================================================================================
#  Install packages from Fedora repos

{ log "Installing system packages from Terra..."; } 2> /dev/null

dnf5 install -y "${SYSTEM_PACKAGES_TERRA_REPO[@]}"

# ======================================================================================
#  Install Steam from Terra repos

{ log "Installing Steam..."; } 2> /dev/null

dnf5 install --exclude=${EXCLUDED_STEAM_PACKAGES} -y "${STEAM_PACKAGES_TERRA_REPO[@]}"

# ======================================================================================
#  Enable ublue's flatpak-test COPR and update flatpak package

# COPR_REPO="ublue-os/flatpak-test"

# { log "Enabling Ublue's flatpak COPR and updating flatpak..."; } 2> /dev/null

# copr_update

# ======================================================================================
#  Enable ublue's packages COPR and install packages

COPR_REPO="ublue-os/packages"
COPR_PACKAGES=("${UBLUE_COPR_PACKAGES[@]}")

{ log "Enabling Ublue's package COPR and installing packages..."; } 2> /dev/null

copr_install

# ======================================================================================
#  Enable jackgreiner's COPR and install wallpaper-engine-kde-plugin

COPR_REPO="jackgreiner/wallpaper-engine-kde-plugin"
COPR_PACKAGES=("wallpaper-engine-kde-plugin")

{ log "Enabling jackgreiner's COPR and installing wallpaper-engine-kde-plugin..."; } 2> /dev/null

copr_install

# ======================================================================================
#  Install packages from external repos

{ log "Installing external packages..."; } 2> /dev/null

dnf5 install -y "${EXTERNAL_PACKAGES[@]}"

# ======================================================================================
#  Disable Terra repo due to build errors

{ log "Disabling Terra repo..."; } 2> /dev/null

# dnf5 -y config-manager setopt terra.repo_gpgcheck=0

sed -i "s|^enabled=1|enabled=0|" /etc/yum.repos.d/terra.repo
# rm /etc/yum.repos.d/terra.repo

{ log "Done"; } 2> /dev/null


