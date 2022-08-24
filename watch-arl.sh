#!/bin/bash

readonly numparms=1
[ $# -ne $numparms ] && { echo "Usage: $0 veeam12 "; echo "Purpose: $0 continuously to monitor the RL MTree mount-point"; exit 1; }

mtreeAppName=$1

watch "ls -lR /mnt/nfs/$mtreeAppName-rl-mntpt"
