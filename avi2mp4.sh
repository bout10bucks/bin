#!/bin/bash
#
# Change this to specify a different handbrake preset. You can list them by running: "HandBrakeCLI --preset-list"
#
PRESET="Normal"
if [ -z "$1" ] ; then
	TRANSCODEDIR="."
else
TRANSCODEDIR="$1"
fi
find "$TRANSCODEDIR"/*.avi -type f -exec bash -c 'HandBrakeCLI -i "$1" -o "${1%\.*}".mp4 --preset="$PRESET" -O -5' __ {} \;
