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
    "cockpit-navigator"
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
)

EXCLUDED_PACKAGE_FEDORA_REPO="cockpit-ostree,cockpit-podman,cockpit-packagekit"

ADD_PACKAGES_RPMFUSION_REPO=(
    "steam"
    "steam-devices"
)

EXCLUDED_PACKAGE_RPMFUSION_REPO="gamemode"

ADD_PACKAGES_TERRA_REPO=(
    "firacode-nerd-fonts"
)

ADD_PACKAGE_COPR_ATIM=(
    "starship"
    )

ADD_PACKAGES_COPR_UBLUE=(
    "ublue-fastfetch"
	"ublue-motd"
)
# ======================================================================================
#  Remove uneeded packages from Kinoite

log "Removing packages..."
    dnf remove -y ${REMOVE_PACKAGES[@]}

# ======================================================================================
#  Install packages from fedora repos

log "Installing packages from fedora repos..."
    dnf install --skip-broken --skip-unavailable --exclude=${EXCLUDED_PACKAGE_FEDORA_REPO} -y ${ADD_PACKAGES_FEDORA_REPO[@]}

# ======================================================================================
#  Check if rpmfusion is installed then activate them

log "Checking rpm-fusion repos..."
if dnf repolist --all | grep -q rpmfusion; then
    dnf config-manager setopt "rpmfusion*".enabled=1
else # else install it
    dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    # dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA_VERSION.noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$FEDORA_VERSION.noarch.rpm # Fallback
fi

# ======================================================================================
#  Install packages from rpm-fusion repos

log "Installing packages from rpm-fusion..."
    # dnf install --skip-broken --skip-unavailable -y --repo="rpmfusion*" ${ADD_PACKAGES_RPMFUSION_REPO}
    dnf install --skip-broken --skip-unavailable -y --exclude=${EXCLUDED_PACKAGE_RPMFUSION_REPO} ${ADD_PACKAGES_RPMFUSION_REPO[@]}

# ======================================================================================
#  Enable flatpak copr from ublue to use an updated flatpak

log "Enabling Ublue's flatpak repo..."


    REPO="ublue-os/flatpak-test"
    REPO_ID="copr:copr.fedorainfracloud.org:${REPO////:}"

    dnf copr enable -y "${REPO}"
    dnf5 config-manager setopt "${REPO_ID}.priority=1"


# ======================================================================================
#  Update flatpak from Ublue COPR   

log "Update flatpak packages"
    dnf update -y --repo="${REPO_ID}" --allowerasing
    # dnf install --skip-broken --skip-unavailable -y flatpak
    dnf5 config-manager setopt "${REPO_ID}.priority=99"

log "Done"
