#!/bin/bash
timedatectl set-ntp 1
#source partition.sh
sfdisk /dev/sda < part.part
mkfs.ext4 /dev/sda2 && mkfs.ext4 /dev/sda3 && mount /dev/sda2 /mnt && mkdir /mnt/storage && mount /dev/sda3 /mnt/storage
pacstrap /mnt `cat list-pkg`
ls /mnt
genfstab -U /mnt >> /mnt/etc/fstab 
cp chroot.sh /mnt/root/
arch-chroot /mnt /root/chroot.sh
