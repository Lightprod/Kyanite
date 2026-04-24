# shellcheck disable=SC1035
# shellcheck disable=SC1073
# shellcheck disable=SC1036
# shellcheck disable=SC1072
#  vim: set ft=make :

########################
# kyanite-flatpak.just #
########################
## Standardized verbs
# configure- = configure something that is pre-installed on the image
# install-   = install something, no uninstall or configuration provided
# setup-     = install something and also provide configuration and/or uninstallation options
# toggle-    = turn something on/off, logic can be automatic or manual selection
# show-      = Display something, like a config file
# fix-       = apply fix/patch/workaround for something
# foo        = no verb is used for shortcuts or something deemed important enough to use a super memorable name
# testing    = Testing branch recipes


# Show default flatpak installed
[group('Flatpak configuration')]
show-flatpak-defaults-app:
    #!/usr/bin/bash
    set -ouex pipefail

    echo -e "\033[32m'Preinstalled flatpaks:"
    cat /usr/share/kyanite/flatpak/preinstall

# Show flatpak blocklist
[group('Flatpak configuration')]
show-flatpak-blocklist:
    #!/usr/bin/bash
    set -ouex pipefail

    echo -e "\033[31m'Blocked flatpaks:"
    { cat /usr/share/kyanite/flatpak/blocklist } 2> /dev/null

# Setup flatpak
[group('Flatpak configuration')]
setup-flatpak-all:
    #!/usr/bin/bash
    set -ouex pipefail

    sudo /usr/libexec/kyanite/flatpak-manager

# Set up default system flatpaks.
[group('Flatpak configuration')]
install-system-flatpaks:
    #!/usr/bin/bash
    set -ouex pipefail

    flatpak preinstall 