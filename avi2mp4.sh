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
find "$TRANSCODEDIR"/ -iname "*.avi" -o -iname "*.mkv" -type f -exec bash -c 'HandBrakeCLI -i "$1" -o "${1%\.*}".mp4 --preset="$PRESET" -X 1280 -Y 720 -O -5' __ {} \;
