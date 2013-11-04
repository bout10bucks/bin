 #!/bin/bash
 # nvidia -> nouveau
 
 set -e
 
 # check if root
 if [[ $EUID -ne 0 ]]; then
    echo "You must be root to run this script. Aborting...";
    exit 1;
 fi
 
 #sed -i 's//nouveau/' /etc/modules-load.d/whitelist.conf
 echo nouveau >> /etc/modules-load.d/whitelist.conf

 pacman -Rdds --noconfirm nvidia{,-utils} lib32-nvidia-utils
 pacman -S --noconfirm nouveau-dri xf86-video-nouveau lib32-nouveau-dri
 
 #mkinitcpio -p linux
