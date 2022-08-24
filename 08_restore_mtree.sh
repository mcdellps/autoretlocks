#!/bin/bash

readonly numparms=4
[ $# -ne $numparms ] && { echo "Usage: $0$Ddve_User ddve-ip (192.168.1.30) veeam12 20220824_1659 "; echo "Purpose: $0 restore the MTree from a RL copy"; exit 1; }
Ddve_User=$1
Ddve_Name=$2
mtreeAppName=$3
version=$4

# Using source, you can run this script even without setting the executable bit:
source ./functions.sh

restore_fastcopy_mtree $Ddve_User $Ddve_Name $mtreeAppName $version
