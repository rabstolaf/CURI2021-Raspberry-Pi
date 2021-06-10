#!/bin/bash

#Java
echo "Java testing"
cd /home/pi/CSinParallel/Patternlets/java-OpenMPI/00.spmd/ && make 2> /home/pi/err.txt > /dev/null
./run 2>> /home/pi/err.txt 1> /home/pi/outtest.txt
rm Spmd.class

# Pthreads
echo "Pthread Testing"
cd /home/pi/CSinParallel/Patternlets/pthreads/07.barrier/ && make 2>> /home/pi/err.txt > /dev/null
./barrier 2>> /home/pi/err.txt 1>> /home/pi/outtest.txt
rm barrier

# MPI
echo "MPI testing"
cd /home/pi/CSinParallel/Patternlets/MPI/01.masterWorker/ && make 2>> /home/pi/err.txt > /dev/null 
mpirun -np 4 ./masterWorker 2>> /home/pi/err.txt 1>> ~/outtest.txt
rm masterWorker

#mpi4py
echo "mpi4py testng"
cd /home/pi/CSinParallel/Patternlets/mpi4py && python3 run.py 00spmd.py 4 2>> /home/pi/err.txt >> /home/pi/outtest.txt


#hybrid-MPI+OpenMP
echo "hybrid testing"
cd /home/pi/CSinParallel/Patternlets/hybrid-MPI+OpenMP/01.spmd2 && make 2>> /home/pi/err.txt > /dev/null
mpirun -np 4 ./spmd2 2>> ~/err.txt 1>> /home/pi/outtest.txt
rm spmd2

#openMP
echo "openMP testing"
cd /home/pi/CSinParallel/Patternlets/openMP/08.reduction && make 2>> /home/pi/err.txt > /dev/null
./reduction 2>> /home/pi/err.txt 1>> /home/pi/outtest.txt
rm reduction

#check if the patternlets work
patternletsWork=true

# Search for lines in ~/outtest.txt
while IFS= read -r line
do
  if ! grep "$line" ~/outtest.txt > /dev/null
  then
    echo -e "\e[1;31mFOLLOWING LINE NOT DETECTED: $line \e[0m"
    patternletWork=false
  fi
done < /home/pi/CURI2021-Raspberry-Pi/testcheck.txt

#Output if all of the Patternlets worked
if $patternletWork 
then
  echo -e "\e[1;32mPatternlet testing showed no errors \e[0m"
  rm /home/pi/outtest.txt
  rm /home/pi/err.txt
else
  echo -e "\e[1;33mTESTING RESULTED IN ERROR\e[0m"
fi

# In case any of the Patternlets didn't work
if ! $patternletWork
then
  if [ ! -s ~/err.txt ]
  then
    echo -e "\e[1;33mNO ERROR MESSAGES\e[0m"
  else
    echo -e "\e[1;31mERROR MESSAGES PRESENT \e[0m"
    echo "Showing error output"
    echo "######################"
    cat /home/pi/err.txt

  fi
fi

chmod u+x clustercheck.sh
