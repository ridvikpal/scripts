#!/bin/bash

####################
# This script is used to install deb packages.
####################

# first ensure the user is running this script as root
if [[ "${EUID}" -ne 0 ]]; then
   echo "This script must be run as root (use sudo)"
   exit 1
fi

# Path to the file that contains a list of deb packages to install
DEB_PACKAGES_FILE="../text/deb_packages_to_install.txt"

# Ensure the deb packages file exists
if [[ ! -f "${DEB_PACKAGES_FILE}" ]]; then
    echo "Error: Deb packages file '${DEB_PACKAGES_FILE}' not found."
    exit 1
fi

# Load the deb packages into an array
mapfile -t DEB_PACKAGES < "${DEB_PACKAGES_FILE}"

# Inform the user which deb packages will be installed
echo ""
echo "Installing the following deb packages to the machine:"
echo "---------------------------------"
for PACKAGE in "${DEB_PACKAGES[@]}"; do
    echo "${PACKAGE}"
done
echo ""

# then ensure the user has upgraded their machine first
read -rp "This script will install apt packages. Did you run apt update && apt upgrade first? (Y/n) " -n 1
echo ""
if [[ ! "${REPLY}" =~ ^[Yy]$ ]]; then
    # if the user did not, then exit
    exit 1
fi
echo ""

# Install each deb package listed in the txt file line by line
for PACKAGE in "${DEB_PACKAGES[@]}"; do
    apt-get install -y ${PACKAGE}
done
