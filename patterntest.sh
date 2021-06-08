#!/bin/bash

#Java
echo "Java testing"
cd ~/CSinParallel/Patternlets/java-OpenMPI/00.spmd/ && make 2> err.txt > /dev/null
./run 2>> ~/err.txt 1> ~/outtest.txt

# Pthreads
echo "Pthread Testing"
cd ~/CSinParallel/Patternlets/pthreads/07.barrier/ && make 2>> err.txt > /dev/null
./barrier 2>> ~/err.txt 1>> ~/outtest.txt

# MPI
echo "MPI testing"
cd ~/CSinParallel/Patternlets/MPI/01.masterWorker/ && make 2>> err.txt > /dev/null 
mpirun -np 4 ./masterWorker 2>> ~/err.txt 1>> ~/outtest.txt

#mpi4py
echo "mpi4py testng"
cd ~/CSinParallel/Patternlets/mpi4py && python3 run.py 00spmd.py 4 2>>err.txt >> ~/outtest.txt

#hybrid-MPI+OpenMP
echo "hybrid testing"
cd ~/CSinParallel/Patternlets/hybrid-MPI+OpenMP/01.spmd2 && make 2> err.txt > /dev/null
mpirun -np 4 ./spmd2 2>> ~/err.txt 1>> ~/outtest.txt

#openMP
echo "openMP testing"
cd ~/CSinParallel/Patternlets/openMP/08.reduction && make 2> err.txt > /dev/null
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
done < testcheck.txt

#Output if all of the Patternlets worked
if $patternletWork 
then
  echo -e "\e[1;32mPatternlet testing showed no errors \e[0m"
  rm ~/outtest.txt
  rm ~/err.txt
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
    cat ~/err.txt

  fi
fi

#Presenting option to run a cluster (If anything other than Y or YES are submitted (NOT case-sensitive, this part is skipped)
echo "Would you like to test a cluster? [y/N]"
read response
response=${response^^}
if [ $responce -eq "Y" ] || [ $responce -eq "YES" ]
then 
  #creating the head-node and the host file
  echo "Head node and hostfile configuration"
  sudo head-node
  soc-mpisetup
  
  #Testing Cluster on MPI/00.spmd patternlet
  echo "MPI cluster testing"
  cd ~/CSinParallel/Patternlets/MPI/00.spmd/ && make 2>> err.txt > /dev/null 
  mpirun -hostfile ~/hostfile -np 12 ./spmd 2>> ~/err.txt 1>> ~/outtest.txt
  
  #checking for desired output
  clusterWork=true
  while IFS= read -r line
  do
    if ! grep "$line" ~/outtest.txt > /dev/null
    then
      echo -e "\e[1;31mFOLLOWING LINE NOT DETECTED: $line \e[0m"
      clusterWork=false
    fi
  done < clustercheck.txt
  
  #reverting head node to worker node
  echo "Reverting head-node to worker-node"
  sudo worker-node
  
  #Output
  if $clusterWork 
  then
    echo -e "\e[1;32mCluster testing showed no errors \e[0m"
    rm ~/outtest.txt
    rm ~/err.txt
  else
    echo -e "\e[1;32mTESTING THE CLUSTER RESULTED IN ERROR\e[0m"
  fi
else
  echo -e "\e[1;34mCluster head node not tested in this script\e[0m"
fi
