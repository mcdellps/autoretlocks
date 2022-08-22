#!/bin/bash

source ./functions.sh

Ddve_User=${1:-sysadmin}
Ddve_Name=${2:-ddve01}

list_mtree $Ddve_User $Ddve_Name
