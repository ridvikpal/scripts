#!/bin/bash

####################
# This script is used to install snap packages.
####################

# first ensure the user is running this script as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

SNAP_PACKAGES_FILE="../text/snap_packages_to_install.txt"

# Ensure the snap packages file exists
if [[ ! -f "$SNAP_PACKAGES_FILE" ]]; then
    echo "Error: Snap packages file '$SNAP_PACKAGES_FILE' not found."
    exit 1
fi

# Load the snap packages into an array
mapfile -t SNAP_PACKAGES < "$SNAP_PACKAGES_FILE"

# Inform the user which snap packages will be installed
echo ""
echo "Installing the following snap packages:"
echo "---------------------------------"
for PACKAGE in "${SNAP_PACKAGES[@]}"; do
    echo "$PACKAGE"
done
echo ""

# then ensure the user has snapd installed and upgraded their machine first
read -rp "This script will install snap packages. Did you install snapd and run snap refresh first? (Y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    # if the user did not, then exit
    exit 1
fi
echo ""

# Install each snap package listed in the txt file line by line
for PACKAGE in "${SNAP_PACKAGES[@]}"; do
    snap install $PACKAGE
done
