#!/bin/bash

####################
# This script is used to prevent GNOME from idling or sleeping
# using gnome-session-inhibit.
####################

# Setup the reason for the inhibition.
# It will be visible in 'gnome-session-inhibit -l'.
INHIBIT_REASON="Running keep_gnome_awake.sh script"

# Inform the user the system is being inhibited
echo "Inhibiting the GNOME desktop session from idling or suspending"
echo "Reason: $INHIBIT_REASON"
echo "Press [Ctrl+C] to stop the script."
echo ""

# Use gnome-session-inhibit to prevent the desktop session from idling or suspending
gnome-session-inhibit \
    --reason "$INHIBIT_REASON" \
    --inhibit suspend:idle \
    --inhibit-only
