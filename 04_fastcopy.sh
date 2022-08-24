#!/bin/bash

readonly numparms=3
[ $# -ne $numparms ] && { echo "Usage: $0 sysadmin ddve-ip (192.168.1.30) veeam12 "; echo "Purpose: $0 fastcopy a MTree to RL MTree"; exit 1; }
Ddve_User=$1
Ddve_Name=$2
mtreeAppName=$3

# Using source, you can run this script even without setting the executable bit:
source ./functions.sh

# You can also use the built-in. command for the same results:
# . ./functions.sh

mtreeAppNameRl=$mtreeAppName"-rl"

# DATE=$(date +%Y%m%d-%H:%M)
DATE=$(date +%Y%m%d_%H%M)
run_fastcopy_mtree $Ddve_User $Ddve_Name $mtreeAppName $mtreeAppNameRl $DATE
