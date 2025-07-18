#!/bin/sh

# Script: Bluetooth Status
# Author: VictorzllDev
# GitHub: https://github.com/VictorzllDev/dotfiles
# Desc:   Displays Bluetooth status with icons
# Usage:  Bind to a keyboard shortcut or run manually

# -------------------------------
# Main Script Logic
# -------------------------------

# Verify Bluetooth is enabled
if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  echo " 󰂲"
else
  if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
  then 
    echo " 󰂯"
  fi
  echo " 󰂯"
fi
