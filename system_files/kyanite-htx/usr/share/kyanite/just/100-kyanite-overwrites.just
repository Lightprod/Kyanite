# shellcheck disable=SC1035
# shellcheck disable=SC1073
# shellcheck disable=SC1036
# shellcheck disable=SC1072
#  vim: set ft=make :

###########################
# kyanite-overwrites.just #
###########################
## Standardized verbs
# configure- = configure something that is pre-installed on the image
# install-   = install something, no uninstall or configuration provided
# setup-     = install something and also provide configuration and/or uninstallation options
# toggle-    = turn something on/off, logic can be automatic or manual selection
# show-      = Display something, like a config file
# fix-       = apply fix/patch/workaround for something
# foo        = no verb is used for shortcuts or something deemed important enough to use a super memorable name
# testing    = Testing branch recipes


_disabled_recipe:
    #!/usr/bin/bash
    echo '{{RED}}This recipe is not supported on Kyanite.'

[group('Disabled')]
_toggle-updates:
    #!/usr/bin/bash
    ujust _disabled_recipe

[group('Disabled')]
_install-resolve:
    #!/usr/bin/bash
    ujust _disabled_recipe
