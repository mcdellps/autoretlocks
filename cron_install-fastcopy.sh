#!/bin/bash
#
# File: cron_install-fastcopy.sh
#
# crontab -r                                            is to remove everything
# crontab -l | grep -v "bin/runner.sh" | crontab \-     is to keep every line except "bin/runner"
#
# vi /tmp/cron_install-fastcopy.sh ; chmod +x /tmp/cron_install-fastcopy.sh
#

INSTALLCMD=bin/run-fastcopy.sh
cd "$HOME"
[ ! -d bin ] && mkdir bin
[ -f $INSTALLCMD ] || {
cat > $INSTALLCMD <<-"!!"
#!/bin/bash
#
# run run-fastcopy
#
    
date 
/home/mike/script/04_fastcopy.sh sysadmin ddve01 veeam25  
!!
chmod +x $INSTALLCMD 
echo installed $INSTALLCMD
}

INSTALLCRON="#
# Install run-fastcopy and run it every 8 minutes:
# min hour day_mo month day_wk
*/8 * * * * sh \"\$HOME/$INSTALLCMD\" >> /home/mike/script/fast-copy.txt 2>> /home/mike/script/fast-copy.txt"
crontab -l | grep -q '$HOME'/$INSTALLCMD || {
    crontab -l > mycron
    echo "$INSTALLCRON" >> mycron
    crontab mycron
    rm mycron
    echo updated crontab
}

