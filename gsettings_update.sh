#!/bin/bash

# This script changes some hidden gnome settings using gsettings
# for my preferred user experience.

# set the background to black
echo "Setting background to black"
gsettings set org.gnome.desktop.background picture-options 'none'
gsettings set org.gnome.desktop.background primary-color '#000000'
echo "Done setting the background to black"
echo ""

# disable touchpad and trackpoint acceleration
echo "Setting touchpad and pointing stick acceleration to flat"
gsettings set org.gnome.desktop.peripherals.touchpad accel-profile 'flat'
gsettings set org.gnome.desktop.peripherals.pointingstick accel-profile 'flat'
echo "Done setting touchpad and pointing stick acceleration to flat"
echo ""

# disable conflicting VS Code copy line up/down keyboard shortcuts
echo "Disabling move-to-workspace-up/down keyboard shortcuts"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up ['']
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down ['']
echo "Done disabling move-to-workspace-up/down keyboard shortcuts"
echo ""

echo "In case you ever want to reset a gsettings key-value pair, use:"
echo "gsettings reset SCHEMA [:PATH]  KEY"
echo "Ex: gsettings reset org.gnome.desktop.wm.keybindings move-to-workspace-down"
