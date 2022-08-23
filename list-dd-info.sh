#!/bin/bash

# Using source, you can run this script even without setting the executable bit:
source ./functions.sh

# You can also use the built-in. command for the same results:
# . ./functions.sh

Ddve_User=${1:-sysadmin}
Ddve_Name=${2:-ddve01}

list_dd_info $Ddve_User $Ddve_Name
