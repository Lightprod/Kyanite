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

WORK_FOLDER=/tmp/rpm
# GIT_FOLDER=/ctx/ref_files/packages
UPSTREAM_PACKAGES_RM=""

# REF_UPSTREAM_PACKAGES_RM="upstream_packages_rm"

# ====================================================================
# Copy reference files to tmp to avoid problems working with the repo files directly

# log "Copying repo reference files to ${WORK_FOLDER}"

# mkdir ${WORK_FOLDER}
# cp "${GIT_FOLDER}/*" ${WORK_FOLDER}
# cd ${WORK_FOLDER}

# ====================================================================
#  Populating dnf variables

log "Setting up variables"


# EXT_REPOS_URL=(
#     "https://download.docker.com/linux/fedora/docker-ce.repo"
# )

UBLUE_COPR_REPOS=(
    "ublue-os/packages"
    "ublue-os/staging"
)

UBLUE_FLATPAK_COPR="ublue-os/flatpak-test"


BAZZITE_COPR_REPOS=(
    "bazzite-org/bazzite"
    "bazzite-org/bazzite-multilib"
    "bazzite-org/webapp-manager"
)

COPR_REPOS=(
    # "lizardbyte/beta"
    atim/starship
)


# COPR_REPOS=(
#     # "lizardbyte/beta"
#     atim/starship
#     "ublue-os/packages"
#     "ublue-os/staging"
#     "bazzite-org/bazzite"
#     "bazzite-org/bazzite-multilib"
#     "bazzite-org/webapp-manager"
# )

PLASMA_UNSTABLE_COPR_REPO=(
    "solopasha/plasma-unstable"
    "solopasha/kde-gear-unstable"
)

STEAM_ONLY_RPM_FUSION=(
    "rpmfusion-nonfree-steam"
    "rpmfusion-nonfree-steam-debuginfo"
    "rpmfusion-nonfree-steam-source"
)


 # Upstream packages to remove
UPSTREAM_PACKAGES_RM=( 
    "ublue-os-update-services"
)

FEDORA_PACKAGES_INSTALL=(
    "cockpit"
    "cockpit-files"
    "cockpit-ostree"
    "cockpit-navigator"
    "cockpit-bridge"
	"cockpit-networkmanager"
	"cockpit-podman"
	"cockpit-selinux"
	"cockpit-storaged"
	"cockpit-system"
    # "firewalld" Already installed
    "fastfetch"
    "ptyxis"
    # "tmux"  Already installed
    "gvfs"
    "gvfs-smb"
    "gvfs-fuse"
    "gum"
    "waydroid"
    "plasma-discover-rpm-ostree"
    # "plasma-welcome" Already installed
    "snapper"
    "btrfs-assistant"
    "kvantum"
    "mc"
    "atuin"
    "gparted"
)

# RPM_FUSION_PACKAGES_INSTALL=(
#     "steam"
#     "steam-devices"
# )

# TERRA_PACKAGES_INSTALL=(
    # "firacode-nerd-fonts"
# )

TERRA_PACKAGES_INSTALL=(
    "firacode-nerd-fonts"
    "steam"
    "steam-devices"
)

# EXT_REPOS_PACKAGES_INSTALL=(
#     "docker-ce" 
#     "docker-ce-cli" 
#     "containerd.io" 
#     "docker-buildx-plugin" 
#     "docker-compose-plugin"
# )

# COPR_PACKAGES_INSTALL=(
#     "starship"
#     "ublue-fastfetch"
# 	"ublue-motd"
#     # "steamdeck-kde-presets-desktop"
#     "wallpaper-engine-kde-plugin"
#     "webapp-manager"
# )

UBLUE_COPR_PACKAGES_INSTALL=(
    "ublue-fastfetch"
	"ublue-motd"
)

UBLUE_FLATPAK_PACKAGES=(
    "flatpak"
    "flatpak-libs"
    "flatpak-session-helper"
)

BAZZITE_COPR_PACKAGES_INSTALL=(
    # "steamdeck-kde-presets-desktop"
    # "wallpaper-engine-kde-plugin" # Removed in Bazzite 43
    "webapp-manager"
)

COPR_PACKAGES_INSTALL=(
    "starship"
)

PLASMA_COPR_PACKAGE_INSTALL=(
    "plasma-bigscreen"
)
# ====================================================================
#  Debug

# display $UPSTREAM_PACKAGES_RM

# ====================================================================
# Remove uneeded packages from base image

log "Clean up upstream images"

	dnf5 remove -y ${UPSTREAM_PACKAGES_RM[@]}

# ====================================================================
# Install packages from Fedora

log "Install packages from Fedora repos"
    dnf5 install --skip-broken --skip-unavailable -y ${FEDORA_PACKAGES_INSTALL[@]}

# ====================================================================
# Disable Steam only rpm-fusion and fully enabling rpm-fusion then install packages

log "Disable Steam only rpm-fusion"

	for REPO_ID in $STEAM_ONLY_RPM_FUSION; do
    	dnf5 config-manager setopt "${REPO_ID}.enabled=0"
    done

# log "Enable full rpm-fusion repo"

    # dnf5 install --skip-broken --skip-unavailable -y  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


# log "Install packages from rpm-fusion repos"
    # dnf5 install --skip-broken --skip-unavailable -y ${RPM_FUSION_PACKAGES_INSTALL[@]} --exclude="gamemode"


# ====================================================================
# Install terra repo and install packages

log "Enable terra repos"

    dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release{,-extras}


log "Install packages from Terra repos"

    dnf5 install --skip-broken --skip-unavailable -y ${TERRA_PACKAGES_INSTALL[@]}

# ====================================================================
# Install external repo and install packages

# log "Install external repos"

#     dnf5 config-manager addrepo --from-repofile="${EXT_REPOS_URL}"

# log "Install packages from Terra repos"

#     dnf5 install --skip-broken --skip-unavailable -y ${EXT_REPOS_PACKAGES_INSTALL[@]}

# ====================================================================
# Enable ublue's copr repos and install packages

log "Enable ublue's copr repos"

    for repos in $UBLUE_COPR_REPOS; do
        REPO_ID="copr:copr.fedorainfracloud.org:${repos////:}"
        dnf5 copr enable $repos -y
        # dnf5 config-manager setopt "${REPO_ID}.priority=1"
    done

log "Install ublue-os copr packages"

    dnf5 install --skip-broken --skip-unavailable -y ${UBLUE_COPR_PACKAGES_INSTALL[@]}


# ====================================================================
# Enable ublue's flatpak copr repos and install packages

log "Enable ublue's copr repos and swap flatpak version" # To be removed once it land on Fedora

    REPO_ID="copr:copr.fedorainfracloud.org:${UBLUE_FLATPAK_COPR////:}"
    dnf5 copr enable ${UBLUE_FLATPAK_COPR} -y
    
    for $package in $UBLUE_FLATPAK_PACKAGES; do
        dnf5 -y --repo="${REPO_ID}" swap $package $package
    done



# ====================================================================
# Enable bazzite's copr repos and install packages

log "Enable bazzite's copr repos"

    for repos in $BAZZITE_COPR_REPOS; do
        REPO_ID="copr:copr.fedorainfracloud.org:${repos////:}"
        dnf5 copr enable $repos -y
        # dnf5 config-manager setopt "${REPO_ID}.priority=1"
    done

log "Install bazzite copr packages"

    dnf5 install --skip-broken --skip-unavailable -y ${BAZZITE_COPR_PACKAGES_INSTALL[@]}

# ====================================================================
# Enable copr repos and install packages

# log "Enable copr repos"

#     for repos in $COPR_REPOS; do
#         REPO_ID="copr:copr.fedorainfracloud.org:${repos////:}"
#         dnf5 copr enable $repos -y
#         # dnf5 config-manager setopt "${REPO_ID}.priority=1"
#     done

# log "Install copr packages"

#     dnf5 install --skip-broken --skip-unavailable -y ${COPR_PACKAGES_INSTALL[@]}

# ====================================================================
# Enable plasma-unstable's copr repos

log "Enable plasma-unstable's copr repos"

    for repos in $PLASMA_UNSTABLE_COPR_REPO; do
        REPO_ID="copr:copr.fedorainfracloud.org:${repos////:}"
        dnf5 copr enable $repos -y
        dnf5 config-manager setopt "${REPO_ID}.priority=1"

        log "Updating KDE and Gears to git version"
        dnf5 upgrade -y --repo="${REPO_ID}" --allowerasing
    done

log "Install plasma-bigscreen"

    dnf5 install --skip-broken --skip-unavailable -y ${PLASMA_COPR_PACKAGE_INSTALL[@]}


log "Done"