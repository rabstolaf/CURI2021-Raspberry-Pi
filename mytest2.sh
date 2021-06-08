#!/bin/bash

rm templog.txt
rm out.txt

cd ~/patternlets/patternlets
cd mpi4py

modules='00spmd.py 01masterWorker.py 02parallelLoopEqualChunks.py 03parallelLoopChunksOf1.py 05messagePassing.py 06messagePassing2.py 07messagePassing3.py 08broadcast.py 09broadcastUserInput.py 10broadcastSendReceive.py 11broadcastList.py 12reduction.py 13reductionList.py 14scatter.py 15gather.py 16ScatterGather.py 17dynamicLoadBalance.py'
echo Testing mpi4py
for module in $modules; do
	python3 run.py $module 4 -f -z -y > ~/CURI2021-Raspberry-Pi/out.txt  2>~/CURI2021-Raspberry-Pi/templog.txt
	source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt $module
done

cd ~/patternlets/patternlets/MPI
directory2='00.spmd 01.masterWorker 02.parallelLoop-equalChunks 03.parallelLoop-chunksOf1 05.messagePassing 05.messagePassing 07.messagePassing3 08.broadcast 09.broadcastUserInput 10.broadcastSendReceive 11.broadcast2 12.reduction 13.reduction2 14.scatter 15.gather 16.barrier 17.barrier+Timing 18.reduce+Timing 19.sequenceNumbers 20.parallelLoopAdvanced 21.broadcast+ParallelLoop 22.scatterLoopGather 23.scatterV+gatherV'
for mod in $directory2; do
	cd $mod
	make > out.txt
	cd ..
done

echo
echo Testing MPI
cd 00.spmd
mpirun -np 4 ./spmd -f -z -y > out.txt 2> templog.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh templog.txt spmd
cd ~/patternlets/patternlets/MPI

cd 01.masterWorker
mpirun -np 4 ./masterWorker -f -z -y > out.txt 2> templog.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh templog.txt 01.masterWorker
cd ~/patternlets/patternlets/MPI

cd 02.parallelLoop-equalChunks 
mpirun -np 4 ./parallelLoopEqualChunks -f -z -y > out.txt 2> templog.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt 02.parallelLoop-equalChunks
cd ~/patternlets/patternlets/MPI

cd 03.parallelLoop-chunksOf1
mpirun -np 4 ./parallelLoopChunksOf1 -f -z -y > ~/CURI2021-Raspberry-Pi/out.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt 03.parallelLoop-chunksOf1
cd ~/patternlets/patternlets/MPI

cd 05.messagePassing
mpirun -np 4 ./messagePassing -f -z -y > ~/CURI2021-Raspberry-Pi/out.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt 05.messagePassing
cd ~/patternlets/patternlets/MPI

cd 06.messagePassing2
mpirun -np 4 ./messagePassing2 -f -z -y > ~/CURI2021-Raspberry-Pi/out.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt 06.messagePassing2
cd ~/patternlets/patternlets/MPI

cd 07.messagePassing3
mpirun -np 4 ./messagePassing3 -f -z -y > ~/CURI2021-Raspberry-Pi/out.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt 07.messagePassing3
cd ~/patternlets/patternlets/MPI

cd 08.broadcast
mpirun -np 4 ./broadcast -f -z -y > ~/CURI2021-Raspberry-Pi/out.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt 08.broadcast
cd ~/patternlets/patternlets/MPI

cd 09.broadcastUserInput
mpirun -np 4 ./broadcast -f -z -y > ~/CURI2021-Raspberry-Pi/out.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh ~/CURI2021-Raspberry-Pi/templog.txt 06.messagePassing
cd ~/patternlets/patternlets/MPI

#Testing Java
echo
echo Testing Java-OpenMPI
cd ~/patternlets/patternlets/java-OpenMPI
directory3='00.spmd 01.masterWorker 02.parallelLoop-equalChunks 03.parallelLoop-chunksOf1 05.messagePassing 06.messagePassing2 07.messagePassing3 08.barrier 09.broadcast 10.broadcastUserInput 11.sendReceivePseudoBroadcast 12.broadcast2 13.reduction 14.reduction2 15.scatter 16.gather 17.barrier+timing 18.reduce+timing 19.sequenceNumbers 20.parallelLoopAdvanced 21.broadcastLoopGather 22.scatterLoopGather 23.scatterV+gatherV'
for dir in $directory3; do
	cd $dir
	make > out.txt > templog.txt
	./run 2 -f -z -y > out.txt 2> templog.txt
	source ~/CURI2021-Raspberry-Pi/emptyCheck.sh templog.txt $dir
	cd ~/patternlets/patternlets/java-OpenMPI
done
echo
#Testing hyhrid
echo Testing hybrid
cd ~/patternlets/patternlets/hybrid-MPI+OpenMP/00.spmd
make > out.txt
mpirun -np 4 ./spmd > out.txt 2> templog.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh templog.txt 00.spmd

cd ~/patternlets/patternlets/hybrid-MPI+OpenMP/01.spmd2 
make > out.txt
mpirun -np 4 ./spmd2 > out.txt 2> templog.txt
source ~/CURI2021-Raspberry-Pi/emptyCheck.sh templog.txt 01.spmd2


#Testing openMP
echo
echo Testing OpenMP
directory4='00.forkJoin'
