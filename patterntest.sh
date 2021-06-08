#!/bin/bash

#Java
echo Java testing
cd ~/patternlets/patternlets/java-OpenMPI/00.spmd/ && make 2> err.txt > /dev/null
./run 2>> ~/err.txt 1> ~/outtest.txt

# Pthreads
echo Pthread Testing
cd ~/patternlets/patternlets/pthreads/07.barrier/ && make 2>> err.txt > /dev/null
./barrier 2>> ~/err.txt 1>> ~/outtest.txt

# MPI
echo MPI testing
cd ~/patternlets/patternlets/MPI/01.masterWorker/ && make 2>> err.txt > /dev/null 
mpirun -np 4 ./masterWorker 2>> ~/err.txt 1>> ~/outtest.txt

#mpi4py
echo mpi4py testng
cd ~/patternlets/patternlets/mpi4py && python3 run.py 00spmd.py 4 2>>err.txt >> ~/outtest.txt

#hybrid-MPI+OpenMP
echo hybrid testing
cd ~/patternlets/patternlets/hybrid-MPI+OpenMP/01.spmd2 && make 2> err.txt > /dev/null
mpirun -np 4 ./spmd2 2>> ~/err.txt 1>> ~/outtest.txt

#openMP
echo openMP testing
cd ~/patternlets/patternlets/openMP/08.reduction && make 2> err.txt > /dev/null
./reduction 2>> err.txt 1>> ~/outtest.txt


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
done < ~/CURI2021-Raspberry-Pi/testcheck.txt

if $patternletWork 
then
  echo -e "\e[1;32mPatternlet testing showed no errors \e[0m"
  #rm outtest.txt
  #rm err.txt
else
  echo -e "\e[1;33mTESTING RESULTED IN ERROR\e[0m"
fi


if ! $patternletWork
then
  if [ ! -s ~/err.txt ]
  then
    echo -e "\e[1;33mNO ERROR MESSAGES\e[0m"
  else
    echo -e "\e[1;31mERROR MESSAGES PRESENT \e[0m"
    echo "Showing error output"
    echo "######################"
    cat ~/err.txt

  fi
fi

