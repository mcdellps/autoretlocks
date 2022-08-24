#!/bin/bash

# Using source, you can run this script even without setting the executable bit:
source ./functions.sh

Ddve_User=${1:-sysadmin}
Ddve_Name=${2:-ddve01}

cleanup_space $Ddve_User $Ddve_Name
