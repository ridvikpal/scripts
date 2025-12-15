#!/bin/bash

# first ensure the user is running this script as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

# then ensure the user has upgraded their machine first
read -rp "This script will install Ubuntu snap packages. Did you run snap refresh first? (Y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    # if the user did not, then exit
    exit 1
fi

# install chromium and related chromium codecs
snap install chromium chromium-ffmpeg

# install spotify
snap install spotify

# install VS Code
snap install code --classic

# install Node JS
snap install node --classic --channel=24
