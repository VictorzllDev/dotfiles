#!/bin/sh
# This file launch the bar/s
for mon in $(polybar --list-monitors | cut -d":" -f1); do
	MONITOR=$mon polybar -q left &
	MONITOR=$mon polybar -q center &
	MONITOR=$mon polybar -q right &
done
