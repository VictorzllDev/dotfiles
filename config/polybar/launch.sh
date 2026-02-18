#!/usr/bin/env bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

for mon in $(polybar --list-monitors | cut -d":" -f1); do
	MONITOR=$mon polybar -q default -c "${HOME}"/.config/polybar/config.ini &
done
