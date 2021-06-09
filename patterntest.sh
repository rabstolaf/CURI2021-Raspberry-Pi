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

#Presenting option to run a cluster (If anything other than Y or YES are submitted (NOT case-sensitive, this part is skipped)
echo "Would you like to test a cluster? [y/N]"
read response
response=${response^^}
if [ $responce -eq "Y" ] || [ $responce -eq "YES" ]
then 
  #creating the head-node and the host file
  sudo head-node
  
  #entering the hd-cluster user
  sudo su hd-cluster << "EOF"
  cd ~
  pwd
  #run the hostfile
  soc-mpisetup
  
  #Testing Cluster on MPI/00.spmd patternlet
  echo "MPI cluster testing"
  cd ~/CSinParallel/Patternlets/MPI/00.spmd/ && make 2>> err.txt > /dev/null 
  mpirun -hostfile ~/hostfile -np 12 ./spmd 2>> /home/pi/err.txt 1>> /home/pi/outtest.txt
  
  #Cleanup the files
  rm spmd
  rm ~/hostfile
  rm ~/openmpi/mca-params.conf
  
  #Exit the hd-cluster account
  EOF
  
  #shut down the workers
  sudo shutdown-workers
  
  #Revert head-node to worker-node
  sudo worker-node
  
  #checking for desired output
  clusterWork=true
  while IFS= read -r line
  do
    if ! grep "$line" /home/pi/outtest.txt > /dev/null
    then
      echo -e "\e[1;31mFOLLOWING LINE NOT DETECTED: $line \e[0m"
      clusterWork=false
    fi
  done < /home/pi/CURI2021-Raspberry-Pi/clustercheck.txt
  
  #Output
  if $clusterWork 
  then
    echo -e "\e[1;32mCluster testing showed no errors \e[0m"
    rm /home/pi/outtest.txt
    rm /home/pi/err.txt
  else
    echo -e "\e[1;32mTESTING THE CLUSTER RESULTED IN ERROR\e[0m"
  fi
else
  echo -e "\e[1;34mCluster head node not tested in this script\e[0m"
fi
