#!/bin/bash
timedatectl set-ntp 1
source partition.sh
mkfs.ext4 /dev/sda2 && mkfs.ext4 /dev/sda3 && mount /dev/sda2 /mnt && mkdir /mnt/storage && mount /dev/sda3 /mnt/storage
pacstrap /mnt `cat list-pkg`
ls /mnt
genfstab -U /mnt >> /mnt/etc/fstab 
arch-chroot /mnt