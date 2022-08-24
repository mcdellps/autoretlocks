#!/bin/bash
#
# File: cron_install-run-mtree.sh
#
# crontab -r                                            is to remove everything
# crontab -l | grep -v "bin/runner.sh" | crontab \-     is to keep every line except "bin/runner"
#

INSTALLCMD=bin/run-listmtree.sh
cd "$HOME"
[ ! -d bin ] && mkdir bin
[ -f $INSTALLCMD ] || {
cat > $INSTALLCMD <<-"!!"
#!/bin/bash
#
# run run-listmtree
#
    
date 
/home/mike/script/list-mtree.sh  
!!
chmod +x $INSTALLCMD 
echo installed $INSTALLCMD
}

INSTALLCRON="
# Install run-listmtree and run it every 5 minutes:
# min hour day_mo month day_wk
*/5 * * * * sh \"\$HOME/$INSTALLCMD\" >> /home/mike/script/list-mtree.txt 2>> /home/mike/script/list-mtree.txt"
crontab -l | grep -q '$HOME'/$INSTALLCMD || {
    crontab -l > mycron
    echo "$INSTALLCRON" >> mycron
    crontab mycron
    rm mycron
    echo updated crontab
}

