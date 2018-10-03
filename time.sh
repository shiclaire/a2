#!/bin/bash
cd ~/

wget https://raw.githubusercontent.com/Bowbee/2018_Group13/master/backup_wordpress.sh?token=AnnFFxSCIL26DUdU8jrIzn-wgFdE6DJVks5bvaMYwA%3D%3D

if [ "$(crontab -l | grep 'no crontab' | wc -l)" -gt 0 ];then
    echo "*/1 * * * * /bin/bash /home/ubuntu/backup_wordpress.sh &" > mycron
    crontab mycron
    rm mycron

elif [ "$(crontab -l | grep backupdata.sh | wc -l)" -eq 0 ];then
    crontab -l > mycron
    echo "*/1 * * * * /bin/bash /home/ubuntu/backup_wordpress.sh &" >> mycron
    crontab mycron
    rm mycron

fi
