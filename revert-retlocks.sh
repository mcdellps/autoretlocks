#!/bin/bash

readonly numparms=4
[ $# -ne $numparms ] && { echo "Usage: $0 $Ddve_User ddve-ip (192.168.1.30) veeam12 filename "; echo "Purpose: $0 lists the retention locks settings on a MTree"; exit 1; }
Ddve_User=$1
Ddve_Name=$2
mtreeAppName=$3
lockedFile=$4

# Using source, you can run this script even without setting the executable bit:
source ./functions.sh

mtreeAppNameRl=$mtreeAppName"-rl"

ssh $Ddve_User@$Ddve_Name mtree retention-lock revert "/data/col1/$mtreeAppNameRl/$lockedFile"
