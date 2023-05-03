#!/bin/bash

readonly numparms=3
[ $# -ne $numparms ] && { echo "Usage: $0 sysadmin ddve-ip (192.168.1.30) veeam12 "; echo "Purpose: $0 sets the retention locks retention-period and auto-lockdelay on MTree"; exit 1; }
Ddve_User=$1
Ddve_Name=$2
mtreeAppName=$3

# Using source, you can run this script even without setting the executable bit:
source ./functions.sh

# You can also use the built-in. command for the same results:
# . ./functions.sh

mtreeAppNameRl=$mtreeAppName"-rl"

list_mtree $Ddve_User $Ddve_Name
# set_ret_locks $Ddve_User $Ddve_Name $mtreeAppNameRl 720min 6day 6day 120min
set_ret_locks sysadmin ddve01 $mtreeAppNameRl 720min 6day 6day 5min
# list_ret_locks $Ddve_User $Ddve_Name $mtreeAppNameRl 
list_mtree $Ddve_User $Ddve_Name
