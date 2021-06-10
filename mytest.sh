#!/bin/bash

cd ~/CSinParallel/Patternlets
cd mpi4py

#Testing mpi4py
modules='00spmd.py 01masterWorker.py 02parallelLoopEqualChunks.py 03parallelLoopChunksOf1.py 05messagePassing.py 06messagePassing2.py 07messagePassing3.py 08broadcast.py 09broadcastUserInput.py 10broadcastSendReceive.py 11broadcastList.py 12reduction.py 13reductionList.py 14scatter.py 15gather.py 16ScatterGather.py 17dynamicLoadBalance.py'
echo Testing mpi4py
for module in $modules; do
	python3 run.py $module 4 -f -z -y > ~/CURI2021-Raspberry-Pi/out.txt  2> ~/CURI2021-Raspberry-Pitemplog.txt
	source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt $module
done

#Testing MPI
echo
echo Testing MPI
cd ~/CSinParallel/Patternlets/MPI
directory2='00.spmd 01.masterWorker 02.parallelLoop-equalChunks 03.parallelLoop-chunksOf1 05.messagePassing 05.messagePassing 07.messagePassing3 08.broadcast 09.broadcastUserInput 10.broadcastSendReceive 11.broadcast2 12.reduction 13.reduction2 14.scatter 15.gather 16.barrier 17.barrier+Timing 18.reduce+Timing 19.sequenceNumbers 20.parallelLoopAdvanced 21.broadcast+ParallelLoop 22.scatterLoopGather 23.scatterV+gatherV'
for mod in $directory2; do
	cd ~/CSinParallel/Patternlets/MPI/$mod
	cFile=$(ls . | grep *.c)
	mpicc -Wall -ansi -pedantic -std=c99 $cFile -o test > ~/CURI2021-Raspberry-Pi/out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
	mpirun -np 4 ./test > out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
	source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt $mod
done

#Testing Java
echo
echo Testing Java-OpenMPI
cd ~/CSinParallel/Patternlets/java-OpenMPI
directory3='00.spmd 01.masterWorker 02.parallelLoop-equalChunks 03.parallelLoop-chunksOf1 05.messagePassing 06.messagePassing2 07.messagePassing3 08.barrier 09.broadcast 10.broadcastUserInput 11.sendReceivePseudoBroadcast 12.broadcast2 13.reduction 14.reduction2 15.scatter 16.gather 17.barrier+timing 18.reduce+timing 19.sequenceNumbers 20.parallelLoopAdvanced 21.broadcastLoopGather 22.scatterLoopGather 23.scatterV+gatherV'
for dir in $directory3; do
	cd $dir
	make > ~/CURI2021-Raspberry-Pi/out.txt > ~/CURI2021-Raspberry-Pi/templog.txt
	./run 2 -f -z -y > ~/CURI2021-Raspberry-Pi/out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
	source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt $dir
	cd ~/CSinParallel/Patternlets/java-OpenMPI
done
echo
#Testing hyhrid
echo Testing hybrid
cd ~/CSinParallel/Patternlets/hybrid-MPI+OpenMP/00.spmd
make > ~/CURI2021-Raspberry-Pi/out.txt
mpirun -np 4 ./spmd > ~/CURI2021-Raspberry-Pi/out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt 00.spmd

cd ~/CSinParallel/Patternlets/hybrid-MPI+OpenMP/01.spmd2 
make > out.txt
mpirun -np 4 ./spmd2 > ~/CURI2021-Raspberry-Pi/out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt 01.spmd2

#Testing openMP
echo
echo Testing OpenMP
directory4='00.forkJoin 01.forkJoin2 02.spmd 03.spmd2 04.barrier 06.parallelLoop-equalChunks 07.parallelLoop-chunksOf1 08.reduction 09.reduction-userDefined 10.parallelLoop-dynamicSchedule 11.private 12.mutualExclusion-atomic 13.mutualExclusion-critical 14.mutualExclusion-critical2 15.mutualExclusion-critical3 16.sections'
for mod in $directory4;do
	cd ~/CSinParallel/Patternlets/openMP/$mod
	#pwd
	cFile=$(ls . | grep *.c)
	gcc -Wall -ansi -pedantic -std=c99 $cFile -o test -fopenmp > ~/CURI2021-Raspberry-Pi/out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
	./test 4 > ~/CURI2021-Raspberry-Pi/out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
	source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt $mod
done

#Testing pthread
echo
echo Testing pthread
directory5='00.forkJoin 01.forkJoin2 02.forkJoin3 03.forkJoin4 04.forkJoin5 05.forkJoin6 06.mutualExclusion 07.barrier'
for mod in $directory5;do
	cd ~/CSinParallel/Patternlets/pthreads/$mod
	#pwd
	cFile=$(ls . | grep *.c)
	gcc -Wall -ansi -pedantic -std=c99 $cFile -o test -lpthread > ~/CURI2021-Raspberry-Pi/out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
	./test 4 > ~/CURI2021-Raspberry-Pi/out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
	source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt $mod	 
	rm out.txt
	rm templog.txt
done

cd ~/CSinParallel/Patternlets/pthreads/08.sharedQueue
make > out.txt 2> templog.txt
./producerConsumer 4 4 4 > ~/CURI2021-Raspberry-Pi/out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt 08.shareQueue

cd ~/CSinParallel/Patternlets/pthreads/04.forkJoin5
make > ~/CURI2021-Raspberry-Pi/out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
./forkJoin5 4 > ~/CURI2021-Raspberry-Pi/out.txt 2> ~/CURI2021-Raspberry-Pi/templog.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh templog.txt 04.forkJoin5 
