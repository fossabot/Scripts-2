#!/bin/bash
# written by madkita.
printf "arch chroot script\n"
sleep 1
# check if the script is being run as root or not.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
printf "listing system disks...\n\n\n"
# list system partitions and their types.
fdisk -l
echo "please enter the name of the partition you want to chroot into (sdXY):"
read -r root
echo "mounting directory: $root"
sleep 2
mount /dev/"$root" /mnt
echo "mounting special directories:"
sleep 2
mount -t proc proc /mnt/proc/
mount --rbind /sys /mnt/sys/
mount --rbind /dev /mnt/dev/
echo "chrooting into $root"
sleep 2
chroot /mnt