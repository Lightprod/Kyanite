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

# ======================================================================================
# Defining variables


REMOVE_PACKAGES=(
    "krfb"
)

ADD_PACKAGES_FEDORA_REPO=(
    "cockpit"
    "cockpit-files"
    # "cockpit-ostree"
    "cockpit-bridge"
	"cockpit-networkmanager"
	# "cockpit-podman"
	"cockpit-selinux"
	"cockpit-storaged"
	"cockpit-system"
    "fastfetch"
    "gvfs"
    "gvfs-smb"
    "gvfs-fuse"
    "gum"
    "mc"
    "atuin"
    "gparted"
    # "plasma-login-manager" # Exist in F44
    "plasma-bigscreen"
    # "plasma-setup" # Exist in F44
)

EXCLUDED_PACKAGE_FEDORA_REPO="cockpit-ostree,cockpit-podman,cockpit-packagekit"


ADD_PACKAGES_TERRA_REPO=(
    "firacode-nerd-fonts"
    "steam"
    "steam-devices"
    "starship"
)

EXCLUDED_PACKAGE_TERRA_REPO="gamemode"


ADD_PACKAGES_COPR_UBLUE=(
    "ublue-fastfetch"
	"ublue-motd"
)

# ======================================================================================
#  Remove uneeded packages from Kinoite

log "Removing packages..."
    dnf5 remove -y ${REMOVE_PACKAGES[@]}

# ======================================================================================
#  Enable fedora-multimedia repo

log "Enabling fedora-multimedia..."
    dnf5 -y config-manager setopt fedora-multimedia.enabled=1

# ======================================================================================
#  Install packages from fedora repos

log "Installing packages from fedora repos..."
    dnf5 --setopt=tsflags=noscripts install --exclude=${EXCLUDED_PACKAGE_FEDORA_REPO} -y ${ADD_PACKAGES_FEDORA_REPO[@]}
    # dnf5 install --skip-broken --skip-unavailable --exclude=${EXCLUDED_PACKAGE_FEDORA_REPO} -y ${ADD_PACKAGES_FEDORA_REPO[@]}
    # exit 1
# ======================================================================================
#  Install Terra repo

log "Installing Terra repo..."
    dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# ======================================================================================
#  Install packages from terra repos

log "Installing packages from Terra..."
    dnf5 --setopt=tsflags=noscripts install --exclude=${EXCLUDED_PACKAGE_TERRA_REPO} -y ${ADD_PACKAGES_TERRA_REPO[@]}

# ======================================================================================
#  Enable flatpak copr from ublue and update flatpak

log "Enabling Ublue's flatpak repo..."


    REPO="ublue-os/flatpak-test"
    REPO_ID="copr:copr.fedorainfracloud.org:${REPO////:}"

    dnf5 copr enable -y "${REPO}"
    dnf5 config-manager setopt "${REPO_ID}.priority=1"

log "Update flatpak package"
    dnf5 update -y --repo="${REPO_ID}" --allowerasing
    # dnf install --skip-broken --skip-unavailable -y flatpak
    dnf5 config-manager setopt "${REPO_ID}.priority=99"

# ======================================================================================
#  Enable wallpaper-engine-kde-plugin COPR Repo and install it

    REPO="jackgreiner/wallpaper-engine-kde-plugin"
    REPO_ID="copr:copr.fedorainfracloud.org:${REPO////:}"


log "Enabling wallpaper-engine-kde-plugin repo..."

    dnf5 copr enable -y "${REPO}"
    dnf5 config-manager setopt "${REPO_ID}.priority=1"

log "Installing wallpaper-engine-kde-plugin"
    dnf5 install -y "wallpaper-engine-kde-plugin"
    dnf5 config-manager setopt "${REPO_ID}.priority=99"


log "Done"
