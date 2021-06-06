#!/bin/bash

#Create a log for output of testing
source test.sh > log.txt 2>&1

#Checking the manifest
diff log.txt manifest.txt
