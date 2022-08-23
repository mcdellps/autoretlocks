#!/bin/bash

# Using source, you can run this script even without setting the executable bit:
source ./functions.sh

# You can also use the built-in. command for the same results:
# . ./functions.sh

Ddve_User=${1:-sysadmin}
Ddve_Name=${2:-ddve01}

ssh $Ddve_User@$Ddve_Name ddboost show stats int 1

## ddboost show stats [interval seconds] [count count]
## ssh $Ddve_User@$Ddve_Name ddboost show stat int 1
## ssh $Ddve_User@$Ddve_Name ddboost show stat interval 2
