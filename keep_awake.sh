#!/bin/bash

# Script to keep the laptop awake using systemd-inhibit and sleep

# Setup the reason for the inhibition.
# It will be visible in 'systemd-inhibit --list'.
INHIBIT_REASON="User is keeping the laptop awake"

# Inform the user the system is being inhibited
echo "Inhibiting the system from idling, sleeping/suspending and shutting down"
echo "Reason: $INHIBIT_REASON"
echo "Press [Ctrl+C] to stop the script and allow system sleep/suspend."
echo ""

# The systemd-inhibit command creates a lock.
# The 'sleep infinity' command keeps the script running indefinitely
# until manually interrupted (e.g., with Ctrl+C).
# The --why and --what flags provide context to the system.
# --what=idle: Prevents the screen from dimming or the system from idling.
# --what=sleep: Prevents system from going into suspend/hibernate.
# --what=shutdown: Prevents system from shutting down/rebooting.
systemd-inhibit \
    --who=$USER \
    --why="$INHIBIT_REASON" \
    --what="idle:sleep:shutdown" \
    sleep infinity

# Inform the user 'sleep infinity' is interrupted (e.g., by Ctrl+C).
echo ""
echo "Inhibition released. The system can now idle, sleep/suspend, and shutdown."
