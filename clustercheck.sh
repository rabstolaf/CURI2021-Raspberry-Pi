#!/bin/bash
#creating the head-node and the host file
sudo head-node
  
#Running multiple subshells, because some commands end the script
#Subshell 1: Running soc-mpisetup
(
sudo su hd-cluster << "EOF"
cd ~
soc-mpisetup
EOF
)

#Subshell 2: Running the MPI job
(
sudo su hd-cluster << "EOF"
cd ~

#Testing Cluster on MPI/00.spmd patternlet
echo "MPI cluster testing"
cd ~/CSinParallel/Patternlets/MPI/00.spmd/ && make 2>> err.txt > /dev/null 

#Run the job
mpirun -hostfile ~/hostfile -np 12 ./spmd 2>> ~/err.txt 1>> ~/outtest.txt
EOF
)

#Subshell 3: Checking the output
(
sudo su hd-cluster << "EOF"
cd ~

#Cleanup the files
rm ~/CSinParallel/Patternlets/MPI/00.spmd/spmd
rm ~/hostfile
rm ~/.openmpi/mca-params.conf
  
#checking for desired output
clusterWork=true
while IFS= read -r line
do
  if ! grep "$line" ~/outtest.txt > /dev/null
  then
    echo -e "\e[1;31mFOLLOWING LINE NOT DETECTED: $line \e[0m"
    clusterWork=false
  fi
done < /home/pi/CURI2021-Raspberry-Pi/clustercheck.txt
  
#Output
if $clusterWork 
then
  echo -e "\e[1;32mCluster testing showed no errors \e[0m"
  rm ~/outtest.txt
  rm ~/err.txt
else
  echo -e "\e[1;31mTESTING THE CLUSTER RESULTED IN ERROR\e[0m"
fi

EOF
)
