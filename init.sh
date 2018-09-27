#!/bin/bash
echo "update apt"
apt update >/dev/null 2>&1

echo "install nginx curl mysql-client"
apt install -y nginx curl mysql-client >/dev/null 2>&1
service nginx start

echo "install crontab"
apt-get install cron

echo "install docker"

cd ~/
curl -fsSL get.docker.com -o get-docker.sh >/dev/null 2>&1
sh get-docker.sh
service docker start

curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir wordpress1 && cd wordpress1
wget https://raw.githubusercontent.com/shiclaire/a2/master/wordpress1/docker-compose.yml
cd ~

mkdir wordpress2 && cd wordpress2
wget https://raw.githubusercontent.com/shiclaire/a2/master/wordpress2/docker-compose.yml
cd ~

mkdir mysql && cd mysql
wget https://raw.githubusercontent.com/shiclaire/a2/master/mysql/docker-compose.yml
cd ~

mkdir nginx && cd nginx
wget https://raw.githubusercontent.com/shiclaire/a2/master/nginx/wp1
wget https://raw.githubusercontent.com/shiclaire/a2/master/nginx/wp2
cd ~

sudo gpasswd -a ubuntu docker


docker-compose -f mysql/docker-compose.yml up -d

docker-compose -f wordpress1/docker-compose.yml up -d

rm /etc/nginx/sites-enabled/*
cp nginx/wp1 /etc/nginx/sites-enabled/
service nginx reload

echo "download the switch file"
wget https://raw.githubusercontent.com/shiclaire/a2/master/switch_wpNew.sh
wget https://raw.githubusercontent.com/shiclaire/a2/master/switch_wpOld.sh


#echo "create a account"

#SITENAME=`curl ifconfig.co`

#wp_install_result=$(php -r 'define("WP_SITEURL", "http://'$SITENAME'");define("WP_INSTALLING", true);require_once("./wp-load.php");require_once("wp-admin/includes/upgrade.php");$response=wp_install("weclcome", admin, "aaa@gmail.com", false, null, "ABC");echo $response;')
