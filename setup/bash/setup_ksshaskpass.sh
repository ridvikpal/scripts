#!/bin/bash

####################
# This script setups up ksshaskpass to store ssh keys in KDE Wallet
####################

echo "Setting up ksshaskpass..."

# first check if ksshaskpass is installed
KSSHASKPASS_PATH=$(which ksshaskpass)

# if it is not installed, then prompt the user to install it
if [ -z "$KSSHASKPASS_PATH" ]; then
    echo "Error: ksshaskpass not found. Please ensure it is installed."
    exit 1
fi

# setup the configuration file path
CONFIG_FILE_PATH="${HOME}/.config/plasma-workspace/env/ssh-askpass.sh"

# write the correct configuration to the
cat <<EOF > "${CONFIG_FILE_PATH}"
#!/bin/sh

export SSH_ASKPASS="${KSSHASKPASS_PATH}"
export SSH_ASKPASS_REQUIRE="prefer"
EOF

# make the configuration file executable
chmod +x "${CONFIG_FILE_PATH}"

echo "Done setting up ksshaskpass"
