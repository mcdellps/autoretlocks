#!/bin/bash

Color_Off='\033[0m'       # Text Reset
Red='\033[0;31m'          # Red
Yellow='\033[0;33m'       # Yellow
Green='\033[0;32m'        # Green

## show_space sysadmin ddve01
#
function show_space()
{
  printf "\n${Yellow} Show space in file system ${Color_Off}\n"
  printf "${Red} ssh $1@$2 filesys show space ${Color_Off}\n"
  ssh $1@$2 filesys show space 
}

function create_mtree()
{
  printf "\n${Yellow} Creating /data/col1/$3 MTree ${Color_Off}\n"
  printf "${Red} ssh $1@$2 mtree create /data/col1/$3 ${Color_Off}\n"
  ssh $1@$2 mtree create /data/col1/$3
}

## ops_mtree sysadmin ddve01 apps [ create | delete ]
#
function ops_mtree()
{
  printf "\n${Yellow} About to $4 /data/col1/$3 MTree ${Color_Off}\n"
  printf "${Red} ssh $1@$2 mtree $4 /data/col1/$3 ${Color_Off}\n"
  ssh $1@$2 mtree $4 /data/col1/$3
}

## list_mtree sysadmin ddve01
#
function list_mtree()
{
  printf "\n${Green} List of MTrees as follow: ${Color_Off}\n"
  printf "${Red} ssh $1@$2 mtree list ${Color_Off}\n"
  ssh $1@$2 mtree list
}

## enable_mtree_rl sysadmin ddve01 apps [ governance | compliance ]
#
function enable_mtree_rl()
{
  printf "\n${Green} Enabling governance retention lock on /data/col1/$3 MTree ${Color_Off}\n"
  printf "${Red} ssh $1@$2 mtree retention-lock enable mode $4 mtree /data/col1/$3 ${Color_Off}\n"
  ssh $1@$2 mtree retention-lock enable mode $4 mtree /data/col1/$3
}

## cleanup_space sysadmin ddve01
#
function cleanup_space()
{
  printf "\n${Green} Cleaning up DD filesystems ${Color_Off}\n"
  printf "${Red} ssh $1@$2 filesys show space ${Color_Off}\n"
  ssh $1@$2 filesys show space 
  printf "${Red} ssh $1@$2 filesys clean start ${Color_Off}\n"
  ssh $1@$2 filesys clean start 
  printf "${Red} ssh $1@$2 filesys status ${Color_Off}\n"
  ssh $1@$2 filesys status
}

## set_ret_locks sysadmin ddve01 apps_rl 720min 6day 6day 120min
# period: 1min , 1hr , 1day , 1mo , 1year
#
function set_ret_locks()
{
  printf "\n${Green} Set retention locks on /data/col1/$3 MTree ${Color_Off}\n"
  printf "${Red} ssh $1@$2 mtree retention-lock set min-retention-period ${4} mtree /data/col1/$3 ${Color_Off}\n"
  ssh $1@$2 mtree retention-lock set min-retention-period ${4} mtree /data/col1/$3
  printf "${Red} ssh $1@$2 mtree retention-lock set max-retention-period ${5} mtree /data/col1/$3 ${Color_Off}\n"
  ssh $1@$2 mtree retention-lock set max-retention-period ${5} mtree /data/col1/$3
  printf "${Red} ssh $1@$2 mtree retention-lock set automatic-retention-period ${6} mtree /data/col1/$3 ${Color_Off}\n"
  echo yes | ssh $1@$2 mtree retention-lock set automatic-retention-period ${6} mtree /data/col1/$3
  printf "${Red} ssh $1@$2 mtree retention-lock set automatic-lock-delay ${7} mtree /data/col1/$3 ${Color_Off}\n"
  ssh $1@$2 mtree retention-lock set automatic-lock-delay ${7} mtree /data/col1/$3
}

## list_ret_locks sysadmin ddve01 apps
#
function list_ret_locks()
{
  printf "\n${Green} Display the retention locks settings on /data/col1/$3 MTree ${Color_Off}\n"
  printf "${Red} ssh $1@$2 mtree retention-lock show min-retention-period mtree /data/col1/$3 ${Color_Off}\n"
  ssh $1@$2 mtree retention-lock show min-retention-period mtree /data/col1/$3
  printf "${Red} ssh $1@$2 mtree retention-lock show max-retention-period mtree /data/col1/$3 ${Color_Off}\n"
  ssh $1@$2 mtree retention-lock show max-retention-period mtree /data/col1/$3
  printf "${Red} ssh $1@$2 mtree retention-lock show automatic-retention-period mtree /data/col1/$3 ${Color_Off}\n"
  ssh $1@$2 mtree retention-lock show automatic-retention-period mtree /data/col1/$3
  printf "${Red} ssh $1@$2 mtree retention-lock show automatic-lock-delay mtree /data/col1/$3 ${Color_Off}\n"
  ssh $1@$2 mtree retention-lock show automatic-lock-delay mtree /data/col1/$3
}

## list_mtree sysadmin ddve01 [ mtree-name | all ]
#
function gen_ret_locks()
{
  printf "\n${Green} Generate the retention locks in details ${Color_Off}\n"
  printf "${Red} ssh $1@$2 mtree retention-lock mtree retention-lock report generate retention-details mtrees $3 ${Color_Off}\n"
  ssh $1@$2 mtree retention-lock mtree retention-lock report generate retention-details mtrees $3
}

## run_fastcopy_mtree sysadmin ddve01 apps apps_rl 20220818
#
function run_fastcopy_mtree()
{
  printf "\n${Green} Performing a fastcopy MTree ${Color_Off}\n"
  printf "${Red} ssh $1@$2 filesys fastcopy source /data/col1/$3 destination /data/col1/$4/$5 ${Color_Off}\n"
  ssh $1@$2 filesys fastcopy source /data/col1/$3 destination /data/col1/$4/$5 
}

## restore_fastcopy_mtree sysadmin ddve01 apps_rl 20220818 apps 
#
function restore_fastcopy_mtree()
{
  printf "\n${Green} Restoring a fastcopy MTree ${Color_Off}\n"
  printf "${Red} ssh $1@$2 filesys fastcopy force source /data/col1/$1 destination /data/col1/$2/$3 ${Color_Off}\n"
  ssh $1@$2 filesys fastcopy force source /data/col1/$3/$4 destination /data/col1/$5
}

## create_mntpt_client apps_mnt 
#
function create_mntpt_client()
{
  printf "\n${Green} Creating NFS mount point ${Color_Off}\n"
  printf "${Red} sudo mkdir -p /mnt/nfs/$1 ${Color_Off}\n"
  sudo mkdir -p /mnt/nfs/$1
  sudo chmod 0777 /mnt/nfs/$1
}

## cleanup_mntpt_client sysadmin ddve01 apps_mnt
#
function cleanup_mntpt_client()
{
  printf "\n${Green} Cleaning up NFS mount point ${Color_Off}\n"
  printf "${Red} sudo umount /mnt/nfs/$3 ${Color_Off}\n"
  sudo umount /mnt/nfs/$3
  printf "${Red} sudo rmdir /mnt/nfs/$3 ${Color_Off}\n"
  sudo rmdir /mnt/nfs/$3
}

## add_nfs_dd sysadmin ddve01 apps 
#
function add_nfs_dd()
{
  printf "\n${Green} Exporting NFS path ${Color_Off}\n"
  printf "${Red} ssh $1@$2 nfs export create $3 path /data/col1/$3 clients 192.168.50.0/24 ${Color_Off}\n"
  ssh $1@$2 nfs export create $3 path /data/col1/$3 clients 192.168.50.0/24
}

## del_nfs_dd sysadmin ddve01 apps 
#
function del_nfs_dd()
{
  printf "\n${Green} Exporting NFS path ${Color_Off}\n"
  printf "${Red} ssh $1@$2 nfs export destroy $3  ${Color_Off}\n"
  ssh $1@$2 nfs export destroy $3 
}

## mount_nfs_client ddve01 apps apps_mnt
#
function mount_nfs_client()
{
  printf "\n${Green} Mounting NFS mount point ${Color_Off}\n"
  printf "${Red} sudo mount -t nfs -o hard,intr,nolock,nfsvers=3,tcp,rsize=1048600,wsize=1048600,bg $1:/data/col1/$2 /mnt/nfs/$3 ${Color_Off}\n"
  sudo mount -t nfs -o hard,intr,nolock,nfsvers=3,tcp,rsize=1048600,wsize=1048600,bg $1:/data/col1/$2 /mnt/nfs/$3
}

## list_nfs_client apps_mnt
#
function list_nfs_client()
{
  printf "\n${Green} List the content of the NFS mount point ${Color_Off}\n"
  printf "${Red} sudo ls -l /mnt/nfs/$1 ${Color_Off}\n"
  sudo ls -l /mnt/nfs/$1
  printf "${Red} sudo find /mnt/nfs/$1 -print ${Color_Off}\n"
  sudo find /mnt/nfs/$1 -print
  printf "${Red} sudo find /mnt/nfs/$1 -exec stat {} \; ${Color_Off}\n"
  sudo find /mnt/nfs/$1 -exec stat {} \;
}

## list_nfs_client_brief apps_mnt
#
function list_nfs_client_brief()
{
  printf "\n${Green} List the content of the NFS mount point ${Color_Off}\n"
  printf "${Red} sudo ls -laR /mnt/nfs/$1 ${Color_Off}\n"
  sudo ls -laR /mnt/nfs/$1
}

## add_files_to_nfs_client apps_mnt
#
function add_files_to_nfs_client()
{
## TSTAMP=$(date +%Y_%m_%d)   ### 04_04_2020-16_11_33
TDATE=$(date +%Y%m%d-%H:%M)
  var1=$(< ./count.txt)
  ((var1=var1+1))
  echo $var1 > ./count.txt

  printf "\n${Green} Adding files to the NFS mount point ${Color_Off}\n"
  printf "${Red} touch /mnt/nfs/$1/backup_$var1.vbk ${Color_Off}\n"
  printf "${Red} cp ./license.txt /mnt/nfs/$1/metadata_$var1.vbm ${Color_Off}\n"

  touch /mnt/nfs/$1/backup_$var1.vbk
  echo "Veeam Backup at $TDATE" >> /mnt/nfs/$1/backup_$var1.vbk
  cp ./license.txt /mnt/nfs/$1/metadata_$var1.vbm

}

## del_files_from_nfs_client apps_mnt
#
function del_files_from_nfs_client()
{
  printf "\n${Green} List the content of the NFS mount point ${Color_Off}\n"
  printf "${Red} ls -l /mnt/nfs/$1 ${Color_Off}\n"
  ls -l /mnt/nfs/$1
  printf "${Red} find /mnt/nfs/$1 -print ${Color_Off}\n"
  find /mnt/nfs/$1 -print
  printf "${Red} find /mnt/nfs/$1 -exec rm -fr {} \; ${Color_Off}\n"
  find /mnt/nfs/$1 -exec rm -fr {} \;
}

## list_dd_info
#
function list_dd_info()
{

CMDS=(
"config show timezone"
"system show version"
"system show hardware"
"system show uptime"
"system show modelno"
"system show date"
"system show all"
)

  printf "\n${Green} List DD info ${Color_Off}\n"
  for (( i = 0; i < ${#CMDS[@]}; i++ )) ; do
    printf "${Red} ssh $1@$2 ${CMDS[$i]//\"/} ${Color_Off}\n"
    ssh $1@$2 ${CMDS[$i]//\"/}
  done
}

## list_ddboost sysadmin ddve01
#
function list_ddboost()
{
  printf "\n${Green} List ddboost storage units ${Color_Off}\n"
  printf "${Red} ssh $1@$2 ddboost storage-unit show ${Color_Off}\n"
  ssh $1@$2 ddboost storage-unit show
}

## list_ddboost_compression sysadmin ddve01
#
function list_ddboost_compression()
{
  printf "\n${Green} List ddboost storage units compression ${Color_Off}\n"
  printf "${Red} ssh $1@$2 ddboost storage-unit show compression ${Color_Off}\n"
  ssh $1@$2 ddboost storage-unit show compression
}

function out_ddboost()
{
  printf "\n${Green} List ddboost storage units ${Color_Off}\n"
  printf "${Red} ssh $1@$2 ddboost storage-unit show ${Color_Off}\n"
  ssh $1@$2 ddboost storage-unit show > ./ddboost.txt  
}

## list_ipaddress sysadmin ddve01
#
function list_ddboost_compression()
{
  printf "\n${Green} List IP address of the DD appliance ${Color_Off}\n"
  printf "${Red} ssh $1@$2 net show config ${Color_Off}\n"
  ssh $1@$2 net show config
}