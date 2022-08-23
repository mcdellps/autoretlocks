#!/bin/bash

source ./functions.sh

Ddve_User=${1:-sysadmin}
Ddve_Name=${2:-ddve01}

echo -e "DD username = $Ddve_User and DD Ip Address = $Ddve_Name \n"

echo -e "Timezone on the Linux host is set to `cat /etc/timezone`\n"

# list_mtree $Ddve_User $Ddve_Name

echo "EMC Data Domain Virtual Edition" > ./tmp.txt

ssh $Ddve_User@$Ddve_Name config show timezone >> ./tmp.txt 2> ./tmp.log

ssh $Ddve_User@$Ddve_Name system show date >> ./tmp.txt  2>> ./tmp.log

cat ./tmp.txt

## EMC Data Domain Virtual Edition
## The Timezone name is: US/Pacific
## EMC Data Domain Virtual Edition
## Sun Aug 21 04:16:48 PDT 2022
