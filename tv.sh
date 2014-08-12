#!/bin/bash
if [ ! -z $1 ]; then
	time="$1"
else
	time=19
fi
#dvd drive
DEV=sr0

# Disc name (udev)
DVD_NAME=$(udevadm info -n $DEV -q property | sed -n 's/^ID_FS_LABEL=//p')

# Prevent name collision
TMP_NAME () {
NAME=$HOME/.tmp/"$DVD_NAME"
if [[ -e "$NAME" ]]; then
	i=1
	while [[ -e "$NAME-$i" ]]; do
		let i++
	done
GNAME=$NAME-$i
fi
	mv $NAME $GNAME
}

# Copy the disc
TMP_NAME
vobcopy -mvo .tmp/
cd .tmp/$DVD_NAME
input=.

title=$(lsdvd /dev/sr0 | grep Length | sed 's/:/ /g' | awk -v time=$time '$4 < 1 && $5 >= time {print$2}' | cut -c 1-2)
shift
for titlenumber in $title ; do
SUB=$(lsdvd -st $titlenumber /dev/sr0 | awk '/Subtitle/&&/English/ {print $2}' | sed 's/,//g')
HandBrakeCLI -i $input -o "/media/Video/$DVD_NAME-$titlenumber.mp4" -Z "Normal" -t $titlenumber -s scan,$SUB -F 1 --min-duration 300 -5 -O -m $@;
done
