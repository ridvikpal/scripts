#!/bin/bash

####################
# This script is used to install certain snap packages in a Linux PC.
####################

# first ensure the user is running this script as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

# then ensure the user has upgraded their machine first
read -rp "This script will install snap packages. Did you install snapd as per the docs and run snap refresh first? (Y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    # if the user did not, then exit
    exit 1
fi

# install the core snap package
snap install core

# install spotify
snap install spotify

# install VS Code
snap install code --classic
