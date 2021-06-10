# CURI2021 - Raspberry Pi
For testing each node of the Raspberry Pi - every modules of the patternlets:
  1. Chmod u+x runtest.sh
  2. ./runtest.sh
  3. The above script will produce any differences between what version we want and what version we are currently have
  4. If the out put is "$FILE was not run properly", it means that there is either a WARNING or ERROR while trying to run it.

For testing the image - testing and compare version with some minor test:
  1. chmod u+x mytest.sh
  2. ./mytest.sh
  3. The above script will produce a testing for 6 patternlets and 1 module each patternlet
