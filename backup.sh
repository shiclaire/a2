#!/bin/bash

today=`date '+%Y-%m-%d %H:%M:%S'`
bakdir=wordpress-$today

mkdir /home/$bakdir
mkdir /home/$bakdir/site
mkdir /home/$bakdir/mysql

bakfile=/home/wordpress-${today}.tar.gz
[ -f $bakfile ] && rm -rf $bakfile


#Here, the Password is your database password you set. CHANGE it make sure is yours password!!!
mysqldump -uroot -p"1234" -h127.0.0.1 wordpress --all-databases > /home/$bakdir/wordpress_db.sql

tar zcvfP ${bakfile} /home/$bakdir >/dev/null
rm -rf /home/$bakdir

#You can find backup time in /var/log/wp_bak.log
echo $bakfile >> /var/log/wp_bak.log
