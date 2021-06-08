#!/bin/bash
_file="$1"
program="$2"
[ $# -eq 0 ] && { echo "Usage: $0 filename"; exit 1; }
[ ! -f "$_file" ] && { echo "Error: $0 file not found."; exit 2; }
 
if [ -s "$_file" ] 
then
	echo -e "\e[1;31m$program \e[0m  was not run properly"
        # do something as file has data
else
	echo -e "Testing $program : \e[1;32mPassed\e[0m"
        # do something as file is empty 
fi
