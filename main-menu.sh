#!/bin/bash

# red='\e[31m'
# green='\e[32m'
# yellow='\e[33m'
# clear='\e[0m'

clear='\033[0m'           # Text Reset
red='\033[0;31m'          # Red
yellow='\033[0;33m'       # Yellow
green='\033[0;32m'        # Green

source ./functions.sh

program_name=$0

VAL_INIT=1
VAL_CLEAN=2
VAL_DAILY=3
VAL_ALL=4

help_usage()
{
	echo -ne "$yellow $program_name $clear [-hcprf] [-u dd_admin ] [ -n dd_hostname ] [ -m dd_mtree ] \n"
	echo -ne "\t -h   display help \n"
   echo -ne "\t -c   create MTree(s) and setup the retention locks on DD \n"
   echo -ne "\t -s   simulates day to day operations i.e. backup(s) and leveraging the retention locks to provide data immutability \n"
   echo -ne "\t -r   removes the retention locks and MTree(s) on DD \n"
   echo -ne "\t -f   full menu of operations related to retention locks and MTree \n\n"
   echo -ne "Examples: \n"
   echo -ne " $yellow $program_name $clear -h \n"
   echo -ne " $yellow $program_name $clear -c -u sysadmin -n ddve01 -m veeam13 \n"
}

help_init()
{
	echo -ne "$yellow Set-Env $clear                  Set the environment variables - DD_Administrator DD_Hostname Prod_MTree_Name \n\n"
	echo -ne "$yellow Add-Mtree $clear                Add a new prod and Retention Lock (RL) MTree \n"
	echo -ne "$yellow Set-RetLocks $clear             Set the retention locks on the RL MTree \n"
	echo -ne "$yellow Setup-Nfs-Dd-Clnt $clear        Add NFS prod & RL MTree export and all related mount-points \n\n"
	echo -ne "$yellow List-Mtree $clear               Lists the prod and Retention Lock (RL) MTree \n"
	echo -ne "$yellow List-RetLocks $clear            List the retention lock settings on the RL MTree \n\n"
	echo -ne "$yellow Quit $clear      ..........     Exit \n"	
}

help_clean()
{
	echo -ne "$yellow Set-Env $clear                  Set the environment variables - DD_Administrator DD_Hostname Prod_MTree_Name \n\n"
	echo -ne "$yellow Del-Files-Nfs-Clnt-RL $clear    Remove files from NFS RL MTree mount-point (/mnt/nfs) \n"
	echo -ne "$yellow Cleanup-Nfs-Dd-Clnt $clear      Removes NFS prod & RL MTree export and all related mount-points (/mnt/nfs) \n\n"
	echo -ne "$yellow Del-Mtree $clear                Deletes prod and Retention Lock (RL) MTree \n"
	echo -ne "$yellow Quit $clear      ..........     Exit \n"	
}

help_daily()
{
	echo -ne "$yellow Set-Env $clear                  Set the environment variables - DD_Administrator DD_Hostname Prod_MTree_Name \n\n"
	echo -ne "$yellow Run-Backup $clear               Simulating backup(s) by adding files to prod MTree \n"
	echo -ne "$yellow Fastcopy $clear                 Fastcopy the prod MTree to RL MTree \n\n"
	echo -ne "$yellow List-Nfs-Dd-Clnt-Brief $clear   List all the files for prod & RL MTree \n"
	echo -ne "$yellow Quit $clear      ..........     Exit \n"	
}

help_all()
{
	echo -ne "$yellow Set-Env $clear                  Set the environment variables - DD_Administrator DD_Hostname Prod_MTree_Name \n\n"
	echo -ne "$yellow Add-Mtree $clear                Add a new prod and Retention Lock (RL) MTree \n"
	echo -ne "$yellow Set-RetLocks $clear             Set the retention locks on the RL MTree \n"
	echo -ne "$yellow Setup-Nfs-Dd-Clnt $clear        Add NFS prod & RL MTree export and all related mount-points (/mnt/nfs) \n"
	echo -ne "$yellow List-Mtree $clear               Lists the prod and Retention Lock (RL) MTree \n"
	echo -ne "$yellow List-RetLocks $clear            List the retention lock settings on the RL MTree \n\n"
	echo -ne "$yellow Add-Files $clear                Add files to prod MTree \n"
	echo -ne "$yellow Fastcopy $clear                 Fastcopy the prod MTree to RL MTree \n\n"
	echo -ne "$yellow List-Nfs-Clnt-FilesOnly $clear      List all the files in prod MTree \n"
	echo -ne "$yellow List-Nfs-Clnt-RL-FilesOnly $clear   List all the files in RL MTree \n"
	echo -ne "$yellow List-Nfs-Clnt $clear                List all the files in details for prod MTree \n"
	echo -ne "$yellow List-Nfs-Clnt-RL $clear             List all the files in details for RL MTree \n\n"
	echo -ne "$yellow Add-Nfs-Dd $clear    ..........    Add a NFS export for the prod MTree on DD \n"
	echo -ne "$yellow Mnt-Nfs-Clnt $clear                Mount the prod MTree to NFS mount-point (/mnt/nfs) \n"
	echo -ne "$yellow Add-Nfs-Dd-RL $clear               Add a NFS export for the RL MTree on DD \n"
	echo -ne "$yellow Mnt-Nfs-Clnt-RL $clear             Mount the RL MTree to NFS mount-point (/mnt/nfs) \n\n"
	echo -ne "$yellow UMnt-Nfs-Clnt $clear  ..........   Unmount the prod MTree from NFS mount-point (/mnt/nfs) \n"
	echo -ne "$yellow UMnt-Nfs-Clnt-RL $clear            Unmount the RL MTree from NFS mount-point (/mnt/nfs) \n"
	echo -ne "$yellow Del-Nfs-Dd $clear                  Remove the NFS prod MTree export on DD \n"
	echo -ne "$yellow Del-Nfs-Dd-RL $clear               Remove the NFS RL MTree export on DD \n"
	echo -ne "$yellow Del-Mtree $clear                   Deletes prod and Retention Lock (RL) MTree \n\n"
	echo -ne "$yellow Del-Files-Nfs-Clnt-RL $clear    Remove files from NFS RL MTree mount-point (/mnt/nfs) \n"
	echo -ne "$yellow Cleanup-Demo $clear             Remove NFS prod & RL MTree export and all related mount-points  \n"
	echo -ne "$yellow Quit $clear      ..........     Exit \n"
}

menu_init()
{
DD_User=$1
DD_Hostname=$2
DD_MTree=$3
echo -ne "\n$yellow                 SETTING UP RETENTION LOCKS $clear\n"
echo -ne "\n$green                    M A I N    M E N U $clear\n\n"
PS3=$'\n'"Press Enter to see the list of selections"$'\n'"Enter your selection (1-Help, 2-Exit, 3-8): "
while true; do
  select character in Help Quit Set-Env Add-Mtree Set-RetLocks Setup-Nfs-Dd-Clnt List-Mtree List-RetLocks ; do
    case $character in
    Help)
	  help_init
	  ;;
    Set-Env)
	  echo -ne "$green Setting environment variables $clear\n"
     read -p 'DD AdminName: ' DD_User
     read -p 'DD IP/Hostname: ' DD_Hostname
     read -p 'MTree Name: ' DD_MTree
	  ;;
    Add-Mtree)
	  echo -ne "$green Adding a new MTree and RL MTree $clear\n"
	  ./01_add_mtree.sh $DD_User $DD_Hostname $DD_MTree 
	  ;;
    Set-RetLocks)
	  echo -ne "$green Setting the retention locks on the RL MTree $clear\n"
	  ./02_set_retlocks.sh $DD_User $DD_Hostname $DD_MTree  
	  ;;
	 Setup-Nfs-Dd-Clnt)
     DD_MTreeRl=$DD_MTree"-rl"
     ./03a_add_nfs_dd.sh $DD_User $DD_Hostname $DD_MTree  
	  ./03b_mnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTree  
	  ./03a_add_nfs_dd.sh $DD_User $DD_Hostname $DD_MTreeRl  
	  ./03b_mnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTreeRl  
     ;;
    List-Mtree)
	  echo -ne "$green List all the MTrees in DD $clear\n"
	  ./list-mtree.sh $DD_User $DD_Hostname
	  ;;
    List-RetLocks)
	  echo -ne "$green List the retention lock settings on the MTree $clear\n"
	  ./list-retlocks.sh $DD_User $DD_Hostname $DD_MTree
	  ;;
    Quit)
	  break 2
	  ;;		
    *)
	  echo -ne "$red Invalid option $REPLY $clear\n"
	  break
	  ;;	
    esac
  done  ## select
done  ## while
}

menu_clean()
{
DD_User=$1
DD_Hostname=$2
DD_MTree=$3
echo -ne "\n$yellow               CLEANING UP RETENTION LOCKS $clear\n"
echo -ne "\n$green                    M A I N    M E N U $clear\n\n"
PS3=$'\n'"Press Enter to see the list of selections"$'\n'"Enter your selection (1-Help, 2-Exit, 3-5): "
while true; do
  select character in Help Quit Set-Env Del-Files-Nfs-Clnt-RL Cleanup-Nfs-Dd-Clnt Del-Mtree ; do
    case $character in
    Help)
	  help_clean
	  ;;
    Set-Env)
	  echo -ne "$green Setting environment variables $clear\n"
     read -p 'DD AdminName: ' DD_User
     read -p 'DD IP/Hostname: ' DD_Hostname
     read -p 'MTree Name: ' DD_MTree
	  ;;
	 Del-Mtree)
	  echo -ne "$green Deletes the MTree and the RL MTree $clear\n"
	  ./07_del_mtree.sh $DD_User $DD_Hostname $DD_MTree  
	  ;;
	 Del-Files-Nfs-Clnt-RL)
	  echo -ne "$green Deletes files from the NFS RL mount-point on the client $clear\n"
	  DD_MTreeRlMnt=$DD_MTree"-rl-mntpt"
	  del_files_from_nfs_client $DD_MTreeRlMnt
	  ;;
	 Cleanup-Nfs-Dd-Clnt)
     DD_MTreeRl=$DD_MTree"-rl"
	  ./06a_umnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTree
	  ./06b_del_nfs_dd.sh $DD_User $DD_Hostname $DD_MTree  
	  ./06a_umnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTreeRl  
     ./06b_del_nfs_dd.sh $DD_User $DD_Hostname $DD_MTreeRl
     ;;
    Quit)
	  break 2
	  ;;		
    *)
	  echo -ne "$red Invalid option $REPLY $clear\n"
	  break
	  ;;	
    esac
  done  ## select
done  ## while
}

menu_daily()
{
DD_User=$1
DD_Hostname=$2
DD_MTree=$3
echo -ne "\n$yellow                  DAY TO DAY  OPERATIONS $clear\n"
echo -ne "\n$green                    M A I N    M E N U $clear\n\n"
PS3=$'\n'"Press Enter to see the list of selections"$'\n'"Enter your selection (1-Help, 2-Exit, 3-6): "
while true; do
  select character in Help Quit Set-Env Run-Backup Fastcopy List-Nfs-Dd-Clnt-Brief ; do
    case $character in
    Help)
	  help_daily
	  ;;
    Set-Env)
	  echo -ne "$green Setting environment variables $clear\n"
     read -p 'DD AdminName: ' DD_User
     read -p 'DD IP/Hostname: ' DD_Hostname
     read -p 'MTree Name: ' DD_MTree
	  ;;
	 Run-Backup)
	  echo -ne "$green Performing a backup - files added prod NFS mount-point on the client $clear\n"
	  ./05_add_file_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTree  
	  ;;
	 Fastcopy)
	  echo -ne "$green Fastcopy from production MTree to RL MTree $clear\n"
	  ./04_fastcopy.sh $DD_User $DD_Hostname $DD_MTree  
	  ;;
	 List-Nfs-Dd-Clnt-Brief)
     DD_MTreeRl=$DD_MTree"-rl"
	  ./list-nfs-clnt-brief.sh $DD_User $DD_Hostname $DD_MTree
	  ./list-nfs-clnt-brief.sh $DD_User $DD_Hostname $DD_MTreeRl
     ;;
    Quit)
	  break 2
	  ;;		
    *)
	  echo -ne "$red Invalid option $REPLY $clear\n"
	  break
	  ;;	
    esac
  done  ## select
done  ## while
}

menu_all()
{
DD_User=$1
DD_Hostname=$2
DD_MTree=$3
echo -ne "\n$yellow                     FULL OPERATIONS $clear\n"
echo -ne "\n$green                    M A I N    M E N U $clear\n\n"
PS3=$'\n'"Press Enter to see the list of selections"$'\n'"Enter your selection (1-Help, 2-Exit, 3-31): "
while true; do
select character in Help Quit Set-Env -------0------- Add-Mtree Set-RetLocks Setup-Nfs-Dd-Clnt List-Mtree List-RetLocks -------1------- Add-Files Fastcopy -------2------- List-Nfs-Clnt-FilesOnly List-Nfs-Clnt-RL-FilesOnly List-Nfs-Clnt  List-Nfs-Clnt-RL -------3------- Add-Nfs-Dd Mnt-Nfs-Clnt Add-Nfs-Dd-RL Mnt-Nfs-Clnt-RL -------4------- UMnt-Nfs-Clnt UMnt-Nfs-Clnt-RL Del-Nfs-Dd Del-Nfs-Dd-RL Del-Mtree -------5------- Del-Files-Nfs-Clnt-RL Cleanup-Demo; do
  case $character in
  Help)
	help_all
	;;
  Set-Env)
	echo -ne "$green Setting environment variables $clear\n"
   read -p 'DD AdminName: ' DD_User
   read -p 'DD IP/Hostname: ' DD_Hostname
   read -p 'MTree Name: ' DD_MTree
	;;
  Add-Mtree)
	echo -ne "$green Adding a new MTree and RL MTree $clear\n"
	./01_add_mtree.sh $DD_User $DD_Hostname $DD_MTree 
	;;
  Set-RetLocks)
	echo -ne "$green Setting the retention locks on the RL MTree $clear\n"
	./02_set_retlocks.sh $DD_User $DD_Hostname $DD_MTree  
	;;
	Add-Nfs-Dd)
	echo -ne "$green Creates the NFS MTree export on DD $clear\n"
	./03a_add_nfs_dd.sh $DD_User $DD_Hostname $DD_MTree  
	;;
	Mnt-Nfs-Clnt)
	echo -ne "$green Mount the NFS mount-point on the client $clear\n"
	./03b_mnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTree  
	;;
	Add-Nfs-Dd-RL)
	echo -ne "$green Creates the NFS MTree Rl export on DD $clear\n"
   DD_MTreeRl=$DD_MTree"-rl"
	./03a_add_nfs_dd.sh $DD_User $DD_Hostname $DD_MTreeRl  
	;;
	Mnt-Nfs-Clnt-RL)
	echo -ne "$green Mount the NFS Rl mount-point on the client $clear\n"
   DD_MTreeRl=$DD_MTree"-rl"
	./03b_mnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTreeRl  
	;;
	Fastcopy)
	echo -ne "$green Fastcopy from production MTree to RL MTree $clear\n"
	./04_fastcopy.sh $DD_User $DD_Hostname $DD_MTree  
	;;
	Add-Files)
	echo -ne "$green Add some files to a NFS MTree mount-point on the client $clear\n"
	./05_add_file_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTree  
	;;
	UMnt-Nfs-Clnt)
	echo -ne "$green Unmount the NFS mount-point on the client $clear\n"
	./06a_umnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTree  
	;;
	Del-Nfs-Dd)
	echo -ne "$green Deletes the NFS MTree export on DD $clear\n"
	./06b_del_nfs_dd.sh $DD_User $DD_Hostname $DD_MTree  
	;;
	UMnt-Nfs-Clnt-RL)
	echo -ne "$green Unmount the NFS Rl mount-point on the client $clear\n"
   DD_MTreeRl=$DD_MTree"-rl"
	./06a_umnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTreeRl  
	;;
	Del-Nfs-Dd-RL)
	echo -ne "$green Deletes the NFS MTree Rl export on DD $clear\n"
   DD_MTreeRl=$DD_MTree"-rl"
	./06b_del_nfs_dd.sh $DD_User $DD_Hostname $DD_MTreeRl  
	;;
	Del-Mtree)
	echo -ne "$green Deletes the MTree and the RL MTree $clear\n"
	./07_del_mtree.sh $DD_User $DD_Hostname $DD_MTree  
	;;
  List-Mtree)
	echo -ne "$green List all the MTrees in DD $clear\n"
	./list-mtree.sh $DD_User $DD_Hostname
	;;
	List-Nfs-Clnt)
	echo -ne "$green List the NFS mount-point on the client $clear\n"
	./list-nfs-clnt.sh $DD_User $DD_Hostname $DD_MTree
	;;
	List-Nfs-Clnt-FilesOnly)
	echo -ne "$green List the NFS mount-point on the client $clear\n"
	./list-nfs-clnt-brief.sh $DD_User $DD_Hostname $DD_MTree
	;;
	List-Nfs-Clnt-RL)
	echo -ne "$green List the NFS RL mount-point on the client $clear\n"
   DD_MTreeRl=$DD_MTree"-rl"
	./list-nfs-clnt.sh $DD_User $DD_Hostname $DD_MTreeRl
	;;
	List-Nfs-Clnt-RL-FilesOnly)
	echo -ne "$green List the NFS RL mount-point on the client $clear\n"
   DD_MTreeRl=$DD_MTree"-rl"
	./list-nfs-clnt-brief.sh $DD_User $DD_Hostname $DD_MTreeRl
	;;
	Del-Files-Nfs-Clnt-RL)
	echo -ne "$green Deletes files from the NFS RL mount-point on the client $clear\n"
	DD_MTreeRlMnt=$DD_MTree"-rl-mntpt"
	del_files_from_nfs_client $DD_MTreeRlMnt
	;;
	List-RetLocks)
	echo -ne "$green List the retention lock settings on the MTree $clear\n"
	./list-retlocks.sh $DD_User $DD_Hostname $DD_MTree
	;;
	Setup-Nfs-Dd-Clnt)
   DD_MTreeRl=$DD_MTree"-rl"
   ./03a_add_nfs_dd.sh $DD_User $DD_Hostname $DD_MTree  
	./03b_mnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTree  
	./03a_add_nfs_dd.sh $DD_User $DD_Hostname $DD_MTreeRl  
	./03b_mnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTreeRl  
  ;;
	Cleanup-Demo)
   DD_MTreeRl=$DD_MTree"-rl"
	./06a_umnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTree
	./06b_del_nfs_dd.sh $DD_User $DD_Hostname $DD_MTree  
	./06a_umnt_nfs_clnt.sh $DD_User $DD_Hostname $DD_MTreeRl  
  ./06b_del_nfs_dd.sh $DD_User $DD_Hostname $DD_MTreeRl
  ./07_del_mtree.sh $DD_User $DD_Hostname $DD_MTree 
	;;
  Quit)
	break 2
	;;		
  *)
	echo -ne "$red Invalid option $REPLY $clear\n"
	break
	;;	
  esac
done
done
}

selected=VAL_ALL

   while getopts ":hcsrfu:n:m:" option; do
      case $option in
      h) help_usage
         exit;;
      f) selected=VAL_ALL;;
      r) selected=VAL_CLEAN;;
      c) selected=VAL_INIT;;
      s) selected=VAL_DAILY;;
      u) DD_User="$OPTARG" ;;
      n) DD_Hostname="$OPTARG" ;;
      m) DD_MTree="$OPTARG" ;;
      \?) # display Help
         brief_menu
         exit;;
      esac
   done

case $selected in
  VAL_INIT)
    menu_init $DD_User $DD_Hostname $DD_MTree
    ;;
  VAL_CLEAN)
    menu_clean $DD_User $DD_Hostname $DD_MTree
    ;;
  VAL_DAILY)
    menu_daily $DD_User $DD_Hostname $DD_MTree
    ;;
  *)
    menu_all $DD_User $DD_Hostname $DD_MTree
    ;;    
esac

exit
