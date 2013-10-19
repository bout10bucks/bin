#!/bin/bash
	dname=$(mount | awk -F'(/| type)' '/sr0/ {print$7}')
	input=/run/media/bout10bucks/$dname   ##$(mount | awk '/sr0/ {print$3}')
	name=$(read -ra lname <<< $(echo ${dname,,} | sed 's/_/\ /g')&& echo "${lname[@]^}")
if [ ! -z $1 ]; then
	title="-t $1"
else
	title="--main-feature"
fi
shift
HandBrakeCLI -i "$input" -o "/media/Video/$name.mp4" -Z "Normal" $title --min-duration 1140 -5 -O -m -s scan -F 1 -N eng -T $@
##Uncomment to eject the DVD after encoding
#eject /dev/sr0 &&
##Uncomment to show a popup after encoding
#notify-send "Rip Done"
##Uncomment to send email after encoding
#echo "Your encoding $name, has finished" | mutt -s "$name has finished" bout10bucks@gmail.com
##Uncomment to send a text to an ATT phone after encoding
notify-send "$(echo "Your encoding $name has finished")"
