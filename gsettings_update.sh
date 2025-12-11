#!/bin/bash

# set the background to black
gsettings set org.gnome.desktop.background picture-options 'none'
gsettings set org.gnome.desktop.background primary-color '#000000'

# disable touchpad and trackpoint acceleration
gsettings set org.gnome.desktop.peripherals.touchpad accel-profile 'flat'
gsettings set org.gnome.desktop.peripherals.pointingstick accel-profile 'flat'

# disable conflicting VS Code copy line up/down keyboard shortcuts
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down ['']
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up ['']

# In case you ever want to reset a gsettings key-value pair, use:
# gsettings reset SCHEMA [:PATH]  KEY
# Ex: gsettings reset org.gnome.desktop.wm.keybindings move-to-workspace-down
