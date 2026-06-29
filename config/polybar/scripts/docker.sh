#!/bin/sh

if ! systemctl is-active --quiet docker; then
  echo ""
  exit 0
fi

echo 󰡨
