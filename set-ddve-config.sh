#!/bin/bash

source ./functions.sh

Ddve_User=${1:-sysadmin}
Ddve_Name=${2:-ddve01}

echo -e "DD username = $Ddve_User and DD Ip Address = $Ddve_Name \n"

sudo timedatectl set-timezone Australia/Melbourne

# list_mtree $Ddve_User $Ddve_Name
ssh $Ddve_User@$Ddve_Name config set timezone Australia/Melbourne

## MMDDhhmmYYYY
CurDate=$(date +%m%e%k%M%Y)
ssh $Ddve_User@$Ddve_Name system set date $CurDate
