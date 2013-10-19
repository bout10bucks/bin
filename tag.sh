#!/bin/bash

do_tv() {

if [[ -z $arg ]]; then
	dir="*.mp4"
else 
	dir="$arg*.mp4"
fi

for input in $dir; do

stik="TV Show"
title=$(echo $input | awk -F'( - |.mp4)' '{print $3}') 
series=$(echo $input | awk -F'( - |.mp4)' '{print $1}')
season=$(echo $input | awk -F'( - |.mp4)' '{print $2}' | cut -c 2-3 )
episode=$(echo $input | awk -F'( - |.mp4)' '{print $2}' | cut -d "e" -f2)

#echo "input=$input title=$title series=$series season=$season episode=$episode"; done

AtomicParsley "$input" --metaEnema --title "$title" --stik "$stik" --TVShowName "$series" --TVSeasonNum $season --TVEpisodeNum $episode --freefree --overWrite; done

}

do_movie() {

if [[ -z $arg ]]; then
	dir="*.mp4"
else 
	dir="$arg*.mp4"
fi

for input in $dir; do

stik="Movie"
title=$(echo $input | cut -c-4)

}

while test -n "$1" ; do
case $1 in
  t | tv )
	tv=true
		;;
  m | movie )
	movie=true
		;;
  * )
	arg=$1
		;;
esac
shift
done

if [ "$tv" == "true" ]; then
   do_tv
if [ "$movie" == "true" ]; then
   do_movie
fi

