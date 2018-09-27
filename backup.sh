#!/bin/bash



cd ~/

wget https://raw.githubusercontent.com/LiLoveShi/OMGOMGOMG/master/backup_db.sh

if [ "$(crontab -l | grep 'no crontab' | wc -l)" -gt 0 ];then

    echo "*/5 * * * * /bin/bash /home/ubuntu/backup_db.sh &" > mycron

    crontab mycron

    rm mycron

elif [ "$(crontab -l | grep backup_db.sh | wc -l)" -eq 0 ];then

    crontab -l > mycron

    echo "*/5 * * * * /bin/bash /home/ubuntu/backup_db.sh &" >> mycron

    crontab mycron

    rm mycron

fi
