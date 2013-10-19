#!/bin/bash
if [ ! -z $(mount | grep '/sr0 on /run/media/$USER/') ]; then

	disc=$(mount | awk -F'(/| type)' '/sr0/ {print$7}')
else
	disc=$(mount | awk -F'(/| type)' '/sr0/ {print$5}')
fi
	input=$(mount | awk '/sr0/ {print$3}')
	name=$(read -ra lname <<< $(echo ${disc,,} | sed 's/_/\ /g')&& echo "${lname[@]^}")

if [[ -z $@ ]]; then
  echo " ${0##*/} <type> <option>
t | tv    - TV ripping with title numbered names
	can enter time in minutes as seperate option
m | movie - Movie ripping with forced subtitles only
	can enter title # as a seperate option
d | dir	  - Encode video files in a directory
	either current directory or can specify
a | animation -  (option) Adds animation tuning"

   exit
fi
#if [ -z $input ]; then
#  echo "No disc found"
#   exit
#fi

do_tv() {
	if [ ! -z $optNumber ]; then
		time="$optNumber"
	else 
		time=19
	fi
	
	title=$(lsdvd /dev/sr0 | grep Length | sed 's/:/ /g' | awk -v time=$time '$4 < 1 && $5 >= time {print$2}' | cut -c 1-2)

for titlenumber in $title ; do
	HandBrakeCLI -i $input -o "/media/Video/$name-$titlenumber.mp4" -Z "Normal" -t $titlenumber --min-duration 300 -5 -O -m $xopts ;
	done
#echo time=$time disc=$disc
}

do_movie() {
	if [ ! -z $optNumber ]; then
		title="-t $1"
	else
		title="--main-feature"
	fi
HandBrakeCLI -i "$input" -o "/media/Video/$name.mp4" -Z "Normal" $title --min-duration 1140 -5 -O -m -s scan,1,2 -F 1 --subtitle-default 1 -T $opts1 $xopts

}

do_transcode() {
	if [ -z "$xopts" ] ; then
		TRANSCODEDIR="."
	else
		TRANSCODEDIR="$xopts"
	fi
find "$TRANSCODEDIR"/ -iname "*.(avi|mp4|mkv|m4v)" -type f -exec bash -c 'HandBrakeCLI -i "$1" -o "${1%\.*}".mp4 -Z "Normal" -O -m -5' __ {} \;

}

while test -n "$1" ; do
case $1 in
  t | tv )
	tv=true
		;;
  m | movie )
	movie=true
		;;
  a | --animation)
	opts1="--x264-tune animation"
		;;
 [0-9] | [0-9][0-9] )
	optNumber=$1
		;;
  d | dir )
	dir=true
		;;
  *) 
	xopts=$1
		;;
esac
shift
done

if [ "$movie" == "true" ]; then
   do_movie
fi

if [ "$tv" == "true" ]; then
   do_tv
fi

if [ "$dir" == "true" ]; then
   do_transcode
fi

echo "Your encoding $name, has finished" | mutt -s "$name has finished" bout10bucks@gmail.com
