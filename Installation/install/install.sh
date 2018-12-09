#!/bin/bash

#Colors
BG_WHITE='\033[107m'
BG_GRAY='\033[100m'
BG_BLACK='\033[40m'
BG_ORANGE='\033[43m'
WHITE='\033[37m'
RED='\033[91m'
YELLOW='\033[93m'
GREEN='\033[92m'
NC='\033[40;37m'
#Set colors
echo -e "${NC}"

#Program
echo -e "\t\t${YELLOW}[Running]${WHITE} Set datetime${NC}"
timedatectl set-ntp 1
echo -e "\x1b\x5b\x41\t\t${GREEN}[Done]${WHITE} Set datetime${NC}"

echo -e "\t\t${YELLOW}[Running]${WHITE} Partitioning${NC}"
sfdisk /dev/sda < part
echo -e "\x1b\x5b\x41\t\t${GREEN}[Done]${WHITE} Partitioning${NC}"

echo -e "\t\t${YELLOW}[Running]${WHITE} Formatting and mounting${NC}"
mkfs.ext4 /dev/sda2 && mkfs.ext4 /dev/sda3 && mount /dev/sda2 /mnt && mkdir /mnt/storage && mount /dev/sda3 /mnt/storage
echo -e "\x1b\x5b\x41\t\t${GREEN}[Done]${WHITE} Formatting and mounting${NC}"

echo -e "\t\t${YELLOW}[Running]${WHITE} Installation of basic packages${NC}"
pacstrap /mnt base base-devel
echo -e "\x1b\x5b\x41\t\t${GREEN}[Done]${WHITE} Installation of basic packages${NC}"

echo -e "\t\t${YELLOW}[Running]${WHITE} Generate fstab file${NC}"
ls /mnt
genfstab -U /mnt >> /mnt/etc/fstab
echo -e "\x1b\x5b\x41\t\t${GREEN}[Done]${WHITE} Generate fstab file${NC}"

echo -e "\t\t${YELLOW}[Run]${WHITE} Chroot script${NC}"
cp chroot.sh /mnt/root/
cp list-pkg /mnt/root/
arch-chroot /mnt /root/chroot.sh
echo -e "\t\t${GREEN}[Done]${WHITE} Chroot script${NC}"
