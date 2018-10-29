#!/bin/bash

pacman -Sy --noconfirm git
git clone http://github.com/Air-ESIEA/Skylab
cd Skylab/install
./iso.sh
