#! /bin/bash
date=$(date +%F)
git clone https://github.com/Air-ESIEA/Skylab
zip -r $date-Skylab.zip Skylab/
rm -rf Skylab/
