#!/bin/bash
#
# File: cron_install-add-files.sh
#
# crontab -r                                            is to remove everything
# crontab -l | grep -v "bin/cron_install-add-files.sh.sh" | crontab \-     is to keep every line except "bin/cron_install-add-files.sh"
#
# vi /tmp/cron_install-add-files.sh.sh ; chmod +x /tmp/cron_install-add-files.sh
#

INSTALLCMD=bin/run-addfiles.sh
cd "$HOME"
[ ! -d bin ] && mkdir bin
[ -f $INSTALLCMD ] || {
cat > $INSTALLCMD <<-"!!"
#!/bin/bash
#
# run run-addfiles
#
    
date 
/home/mike/script/05_add_file_nfs_clnt.sh sysadmin ddve01 veeam25  
!!
chmod +x $INSTALLCMD 
echo installed $INSTALLCMD
}

INSTALLCRON="#
# Install run-addfiles and run it every 3 minutes:
# min hour day_mo month day_wk
*/3 * * * * sh \"\$HOME/$INSTALLCMD\" >> /home/mike/script/add-files.txt 2>> /home/mike/script/add-files.txt"
crontab -l | grep -q '$HOME'/$INSTALLCMD || {
    crontab -l > mycron
    echo "$INSTALLCRON" >> mycron
    crontab mycron
    rm mycron
    echo updated crontab
}

