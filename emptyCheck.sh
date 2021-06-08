#!/bin/bash
_file="$1"
program="$2"
[ $# -eq 0 ] && { echo "Usage: $0 filename"; exit 1; }
[ ! -f "$_file" ] && { echo "Error: $0 file not found."; exit 2; }
 
if [ -s "$_file" ] 
then
	echo "$program was not run properly"
        # do something as file has data
else
	echo "Testing $program : Passed"
        # do something as file is empty 
fi
