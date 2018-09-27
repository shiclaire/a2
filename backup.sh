#!/bin/bash



cd ~/

wget https://raw.githubusercontent.com/shiclaire/a2/master/backupdata.sh

if [ "$(crontab -l | grep 'no crontab' | wc -l)" -gt 0 ];then

    echo "*/5 * * * * /bin/bash /home/ubuntu/backup_db.sh &" > mycron

    crontab mycron

    rm mycron

elif [ "$(crontab -l | grep backup_db.sh | wc -l)" -eq 0 ];then

    crontab -l > mycron

    echo "*/5 * * * * /bin/bash /home/ubuntu/backupdata.sh &" >> mycron

    crontab mycron

    rm mycron

fi
