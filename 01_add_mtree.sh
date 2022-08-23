#!/bin/bash

readonly numparms=3
[ $# -ne $numparms ] && { echo "Usage: $0 $Ddve_User ddve-ip (192.168.1.30) veeam12 "; echo "Purpose: $0 creates a MTree and another one for RL "; exit 1; }
Ddve_User=$1
Ddve_Name=$2
mtreeAppName=$3

# Using source, you can run this script even without setting the executable bit:
source ./functions.sh

# You can also use the built-in. command for the same results:
# . ./functions.sh

mtreeAppNameRl=$mtreeAppName"-rl"

list_mtree $Ddve_User $Ddve_Name
ops_mtree $Ddve_User $Ddve_Name $mtreeAppName create
ops_mtree $Ddve_User $Ddve_Name $mtreeAppNameRl create
enable_mtree_rl $Ddve_User $Ddve_Name $mtreeAppNameRl governance
list_mtree $Ddve_User $Ddve_Name
