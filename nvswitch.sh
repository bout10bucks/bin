#!/bin/bash
nouveau=`pacman -Qqs nouveau`
wd=`pwd`
if [ -z "$nouveau" ]; then
pacman -Rdds --noconfirm nvidia-304xx{,utils} lib32-nvidia-304xx-utils
pacman -S --noconfirm xf86-video-nouveau
	if [ -e "/etc/X11/xorg.conf.d/20-nouveau.conf.bkup" ];then
echo "Section "Device"\n    Identifier "Nvidia card"\n    Driver "nouveau"\nEndSection" > /etc/X11/xorg.conf.d/20-nouveau.conf.bkup
	fi
cd /etc/X11/xorg.conf.d/;mv 20-nvidia.conf 20-nvidia.conf.bkup; mv 20-nouveau.conf.bkup 20-nouveau.conf; cd $pwd 
else
pacman -Rdds --noconfirm xf86-video-nouveau {,lib32-}mesa-libgl nouveau-dri
pacman -S --noconfirm nvidia-304xx{.utils} lib32-nvidia-304xx-utils
cd /etc/X11/xorg.conf.d/;mv 20-nouveau.conf 20-nouveau.conf.bkup; mv 20-nvidia.conf.bkup 20-nvidia.conf; cd $pwd 
fi 
