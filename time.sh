#!/bin/bash

wget https://raw.githubusercontent.com/shiclaire/a2/master/bu.sh
apt-get install cron

if [ "$(crontab -l | grep 'no crontab' | wc -l)" -gt 0 ];then
    echo "*/1 * * * * /bin/bash /home/ubuntu/bu.sh &" > mycron
    crontab mycron
    rm mycron

elif [ "$(crontab -l | grep backupdata.sh | wc -l)" -eq 0 ];then
    crontab -l > mycron
    echo "*/1 * * * * /bin/bash /home/ubuntu/bu.sh &" >> mycron
    crontab mycron
    rm mycron

fi
