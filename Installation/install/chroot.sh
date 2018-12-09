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
echo -e "\t\t\t${YELLOW}[Running]${WHITE} Set locales${NC}"
{
  ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
  hwclock --systohc
  sed -i 's/#en_US*/en_US/' /etc/locale.gen && locale-gen && printf 'LANG=en_US.UTF-8' > /etc/locale.conf
} &> $LOG 2> $ERROR
if [$? -ne 0]
then {
  echo -e "\x1b\x5b\x41\t\t\t${YELLOW}[Done]${WHITE} Set locales${NC}"
  echo -e "${BG_ORANGE}${RED}[Error]${WHITE} One or more errors appeared, refer to error.log"
}
else {
  echo -e "\x1b\x5b\x41\t\t\t${GREEN}[Done]${WHITE} Set locales${NC}"
}
echo $ERROR >> $STACK_ERROR


echo -e "\t\t\t${YELLOW}[Running]${WHITE} Update and install packages${NC}"
{
  pacman-key --init
  pacman -Syu --noconfirm < ~/list-pkg
} &> $LOG 2> $ERROR
if [$? -ne 0]
then {
  echo -e "\x1b\x5b\x41\t\t\t${YELLOW}[Done]${WHITE} Update and install packages${NC}"
  echo -e "${BG_ORANGE}${RED}[Error]${WHITE} One or more errors appeared, refer to error.log"
}
else {
  echo -e "\x1b\x5b\x41\t\t\t${GREEN}[Done]${WHITE} Update and install packages${NC}"
}
echo $ERROR >> $STACK_ERROR



echo -e "\t\t\t${YELLOW}[Running]${WHITE} Enable processes at start-up${NC}"
systemctl start sshd && systemctl enable sshd &> $LOG 2> $ERROR
if [$? -ne 0]
then {
  echo -e "\x1b\x5b\x41\t\t\t${YELLOW}[Done]${WHITE} Enable processes at start-up${NC}"
  echo -e "${BG_ORANGE}${RED}[Error]${WHITE} One or more errors appeared, refer to error.log"
}
else {
  echo -e "\x1b\x5b\x41\t\t\t${GREEN}[Done]${WHITE} Enable processes at start-up${NC}"
}
echo $ERROR >> $STACK_ERROR


echo -e "\t\t\t${YELLOW}[Running]${WHITE} Configure bootloader${NC}"
{
  grub-install --target=i386-pc /dev/sda
  grub-mkconfig -o /boot/grub/grub.cfg
} &> $LOG 2> $ERROR
if [$? -ne 0]
then {
  echo -e "\x1b\x5b\x41\t\t\t${YELLOW}[Done]${WHITE} Configure bootloader${NC}"
  echo -e "${BG_ORANGE}${RED}[Error]${WHITE} One or more errors appeared, refer to error.log"
}
else {
  echo -e "\x1b\x5b\x41\t\t\t${GREEN}[Done]${WHITE} Configure bootloader${NC}"
}
echo $ERROR >> $STACK_ERROR


echo -e "\t\t\t${YELLOW}[Running]${WHITE} Create deleteme user${NC}"
{
  useradd deleteme
  echo -e "changeme\nchangeme" | passwd deleteme
} &> $LOG 2> $ERROR
if [$? -ne 0]
then {
  echo -e "\x1b\x5b\x41\t\t\t${YELLOW}[Done]${WHITE} Create deleteme user${NC}"
  echo -e "${BG_ORANGE}${RED}[Error]${WHITE} One or more errors appeared, refer to error.log"
}
else {
  echo -e "\x1b\x5b\x41\t\t\t${GREEN}[Done]${WHITE} Create deleteme user${NC}"
}
echo $ERROR >> $STACK_ERROR



echo -e "\t\t\t${YELLOW}[Running]${WHITE} Configure services${NC}"
{
  echo 'Skylab' > /etc/hostname && printf '127.0.0.1 Skylab\n::1 Skylab\n#10.0.2.15 air.esiea.fr' > /etc/hosts
} &> $LOG 2> $ERROR
if [$? -ne 0]
then {
  echo -e "\x1b\x5b\x41\t\t\t${YELLOW}[Done]${WHITE} Configure services${NC}"
  echo -e "${BG_ORANGE}${RED}[Error]${WHITE} One or more errors appeared, refer to error.log"
}
else {
  echo -e "\x1b\x5b\x41\t\t\t${GREEN}[Done]${WHITE} Configure services${NC}"
}
echo $ERROR >> $STACK_ERROR


echo $LOG >> log.log
echo $STACK_ERROR >> error.log
