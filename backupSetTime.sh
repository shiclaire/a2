#!/bin/bash

#This file is used to backup database every one minute in order to test.
#Here I use my personal public repository bacause this is a privacy repository and maybe have some problems on "wget"
wget https://raw.githubusercontent.com/shiclaire/a2/master/backup.sh
apt-get install cron

if [ "$(crontab -l | grep 'no crontab' | wc -l)" -gt 0 ];then
    echo "*/1 * * * * /bin/bash /home/ubuntu/backup.sh &" > mycron
    crontab mycron
    rm mycron

elif [ "$(crontab -l | grep backupdata.sh | wc -l)" -eq 0 ];then
    crontab -l > mycron
    echo "*/1 * * * * /bin/bash /home/ubuntu/backup.sh &" >> mycron
    crontab mycron
    rm mycron

fi
