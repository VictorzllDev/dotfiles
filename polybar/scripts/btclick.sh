#!/bin/sh

# Script: Bluetooth Toggle
# Author: VictorzllDev
# GitHub: https://github.com/VictorzllDev/dotfiles
# Desc:   Toggles Bluetooth power state and RFKill block
# Usage:  Bind to a keyboard shortcut or run manually

# -------------------------------
# Main Script Logic
# -------------------------------

# Get current Bluetooth power state
STATE=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

if [ "$STATE" = "yes" ]; then
    # Turn Bluetooth off
    bluetoothctl power off
    rfkill block bluetooth
    dunstify "Bluetooth" "Disabled" -i bluetooth
    echo "Bluetooth disabled"
else
    # Turn Bluetooth on
    rfkill unblock bluetooth
    bluetoothctl power on
    dunstify "Bluetooth" "Enabled" -i bluetooth
    echo "Bluetooth enabled"
fi

