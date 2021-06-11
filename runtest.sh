#!/bin/bash

cd ~/CURI2021-Raspberry-Pi
(cd .. ; tar cf - CSinParallel)  |  tar xf -

#Create a log for output of testing
source test.sh > log.txt 2>&1

#Checking the manifest
#If nothing show up, it means it fit the manifest
diff log.txt manifest.txt
rm log.txt
rm manifest.txt

#Checking the patternlets
source patterntest.sh

#checking wifi
ping 8.8.8.8
