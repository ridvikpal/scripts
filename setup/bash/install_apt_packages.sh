#!/bin/bash

####################
# This script is used to install certain apt/deb packages in Debian Linux.
####################

# first ensure the user is running this script as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

# then ensure the user has upgraded their machine first
read -rp "This script will install Debian apt packages. Did you run apt update && apt upgrade first? (Y/n) " -n 1
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    # if the user did not, then exit
    exit 1
fi

# install recommended fonts
apt-get install -y fonts-recommended

# install the default java runtime
apt-get install -y default-jre

# install git
apt-get install -y git

# install python3
apt-get install -y python3 python3-pip python3-venv

# install c, c++ dev packages
apt-get install -y gcc g++ gdb make

# install docker
#apt-get install -y docker.io docker-compose

# install latex via texlive
apt-get install -y texlive texlive-latex-extra chktex

# install libreoffice
apt-get install -y libreoffice libreoffice-gnome

# install vlc
apt-get install -y vlc

# install shotwell
apt-get install -y shotwell
