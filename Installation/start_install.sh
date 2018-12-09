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
pacman -Sy --noconfirm git
git clone http://github.com/Air-ESIEA/Skylab
echo -e "\x1b\x5b\x41${BG_ORANGE}${GREEN}[Downloaded]${WHITE} Installation scripts${NC}"

echo -e "\t${BG_WHITE}${YELLOW}[Run]${WHITE} Installation script${NC}"
cd Skylab/Installation/install
./install.sh
echo -e "\t${BG_WHITE}${GREEN}[Done]${WHITE} Installation script${NC}"

echo -e "${BG_WHITE}${RED}[Finished]${WHITE} Please check error.log to be sure the installation is correct${NC}"
echo "Tape 'reboot' and press enter to reboot"
