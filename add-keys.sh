#!/bin/bash

source ./functions.sh

Ddve_User=${1:-sysadmin}
Ddve_Name=${2:-ddve01}

ssh-keygen

## echo "Username: ddboost@ddve-05.vcorp.local" 
## cat ~admin/.ssh/ddr_key.pub | ssh ddboost@ddve-05.vcorp.local adminaccess add ssh-key

ssh $Ddve_User@$Ddve_Name adminaccess add ssh-keys < ~/.ssh/id_rsa.pub

## ssh $Ddve_User@$Ddve_Name adminaccess del ssh-keys 1
ssh $Ddve_User@$Ddve_Name adminaccess show ssh-keys
ssh $Ddve_User@$Ddve_Name adminaccess trust show
