#!/bin/bash
if [ ! -z $1 ]; then
	time="$1"
else 
	time=19
fi
disc=$(mount | awk -F'(/| type)' '/sr0/ {print$7}')
input=$(mount | awk '/sr0/ {print$3}')
title=$(lsdvd /dev/sr0 | grep Length | sed 's/:/ /g' | awk -v time=$time '$4 < 1 && $5 >= time {print$2}' | cut -c 1-2)
shift
for titlenumber in $title ; do
HandBrakeCLI -i $input -o "/media/Video/$disc-$titlenumber.mp4" -Z "Normal" -t $titlenumber --min-duration 300 -5 -O -m $@;
done

