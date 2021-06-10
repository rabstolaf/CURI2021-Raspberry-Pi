#!/bin/bash
#creating the head-node and the host file
sudo head-node
  
#entering the hd-cluster user
(
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
)
  
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
