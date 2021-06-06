#!/bin/bash

#Checking apt file
pkgs='wget autofs cowsay emacs fping isc-dchp-server libopenmpi3 libopenmpi-dev nfs-kernel-sever openmpi-bin openmpi-common sl vim nmap golang'
for pkg in $pkgs; do
        echo "Package checking: " $pkg
	apt-cache show $pkg | tail -n +1 | head -n2 
	echo
done

#Checking extended file that was not downloaded
echo "Package checking: OpenMPI"
ompi_info | tail -n +1 | head -n2
ompi_info | tail -n +1 | grep "Java bindings: " 
ompi_info | tail -n +1 | grep "Built by: "
echo
#Checking pip installed packages
pip list | grep mpi4py

