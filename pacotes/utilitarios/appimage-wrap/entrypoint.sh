#!/usr/bin/env bash

export PATH="@scriptPATH@:$PATH"

set -eu

if [ $# == 0 ]; then
    echo "No AppImage provided"
    exit 1
fi
APPIMAGE="$1"; shift
OFFSET=$(LC_ALL=C readelf -h "$APPIMAGE" | awk 'NR==13{e_shoff=$5} NR==18{e_shentsize=$5} NR==19{e_shnum=$5} END{print e_shoff+e_shentsize*e_shnum}')
LOOP=$(udisksctl loop-setup --no-user-interaction -f "$APPIMAGE" --offset "$OFFSET" --read-only | sed 's;[ \.];\n;g' | grep '/dev/loop')
MOUNTPOINT=$(udisksctl mount --no-user-interaction -b "$LOOP" | sed 's;[ \.];\n;g' | grep '/media')

if [[ -v REPL ]]; then
    appimage-env
fi

if [ ! -z "$MOUNTPOINT" ]; then
  appimage-env "$MOUNTPOINT/AppRun" "$@"
fi
if [ ! -z "$LOOP" ]; then
  while true; do
    if [[ ! "$(udisksctl unmount --no-user-interaction -b "$LOOP" 2>&1 || true)" =~ "Error" ]]; then
      break
    fi
    sleep 1
  done
  while true; do
    udisksctl loop-delete --no-user-interaction -b "$LOOP" && break || true
    sleep 1
  done
fi
