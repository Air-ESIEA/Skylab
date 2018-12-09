#!/bin/bash

#Syntax
  #to go up \x1b\x5b\x41
  #&> /dev/null 2>> ~/error.log
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
clear
echo -e "${BG_ORANGE}${YELLOW}[Downloading]${WHITE} Installation scripts${NC}"
{
  pacman -Sy --noconfirm git
  git clone http://github.com/Air-ESIEA/Skylab
} &> $LOG 2> $ERROR
if [$? -ne 0]
then {
  echo -e "\x1b\x5b\x41${BG_ORANGE}${YELLOW}[Downloaded]${WHITE} Installation scripts${NC} "
  echo -e "${BG_ORANGE}${RED}[Error]${WHITE} One or more errors appeared, refer to error.log"
}
else {
  echo -e "\x1b\x5b\x41${BG_ORANGE}${GREEN}[Downloaded]${WHITE} Installation scripts${NC} "
}
echo $ERROR >> $STACK_ERROR


echo $LOG >> log.log
echo $STACK_ERROR >> error.log


echo -e "\t${BG_WHITE}${YELLOW}[Run]${WHITE} Installation script${NC}"
cd Skylab/Installation/install
./install.sh
if [$? -ne 0]
then {
  echo -e "\t${BG_WHITE}${YELLOW}[Done]${WHITE} Installation script${NC}"
  echo -e "${BG_ORANGE}${RED}[Error]${WHITE} One or more errors appeared, refer to error.log"
}
else {
  echo -e "\t${BG_WHITE}${GREEN}[Done]${WHITE} Installation script${NC}"
}
echo $ERROR >> $STACK_ERROR


echo -e "${BG_WHITE}${RED}[Finished]${WHITE} Please check error.log to be sure the installation is correct${NC}"
echo "Tape 'reboot' and press enter to reboot"
if [-e "/mnt/root/log.log"]
then
  cp /mnt/root/log.log ~/
if [-e "/mnt/root/error.log"]
then
  cp /mnt/root/error.log ~/
