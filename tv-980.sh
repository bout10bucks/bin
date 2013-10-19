#!/bin/bash
if [ ! -z $1 ]; then
	time="$1"
else 
	time=19
fi
disc=$(mount | awk -F'(/| type)' '/sr0/ {print$5}')
input=$(mount | awk '/sr0/ {print$3}')
title=$(lsdvd /dev/sr0 | grep Length | sed 's/:/ /g' | awk -v time=$time '$4 < 1 && $5 >= time {print$2}' | cut -c 1-2)
shift
for titlenumber in $title ; do
#mkdir -p $disc/dump/
#dump=mplayer dvd://$titlenumber -dvd-device /dev/sr0 -dumpstream -dumpfile $disc/dump/$disc-$titlenumber.vob
#ffmpeg -i -vcodec libx264 -preset veryslow -qp 0 -threads 0 -x264opts ref=2:bframes=2:subme=6:mixed-refs=0:weightb=0:8x8dct=0:trellis=0 -acodec copy $disc-$titlenumber.mkv
HandBrakeCLI -i $input -o "/media/Video/$disc-$titlenumber.mp4" -Z "Normal" -t $titlenumber --min-duration 300 -b 780 -2 -T -5 -O -m $@;
done
