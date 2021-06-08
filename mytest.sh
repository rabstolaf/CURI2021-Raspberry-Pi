#!/bin/bash

cd ~/patternlets/patternlets
cd mpi4py

modules='00spmd.py 01masterWorker.py 02parallelLoopEqualChunks.py 03parallelLoopChunksOf1.py 05messagePassing.py 06messagePassing2.py 07messagePassing3.py 08broadcast.py 09broadcastUserInput.py 10broadcastSendReceive.py 11broadcastList.py 12reduction.py 13reductionList.py 14scatter.py 15gather.py 16ScatterGather.py'

for module in $modules; do
	python3 run.py $module 4 > /dev/null > templog.txt
	source emptyCheck.sh templog.txt $module
done

