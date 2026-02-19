#!/bin/sh

# Script: Bluetooth Status
# Author: VictorzllDev
# GitHub: https://github.com/VictorzllDev/dotfiles
# Desc:   Displays Bluetooth status with icons

# -------------------------------
# Main Script Logic
# -------------------------------

# Verify Bluetooth is enabled
if [ $(echo show | bluetoothctl | grep -c "Powered: yes") -eq 0 ]; then
  echo "󰂲"
else
  if [ $(echo info | bluetoothctl | grep -c 'Device') -eq 0 ]; then
    echo ""
  else
    echo "󰂰"
  fi
fi
