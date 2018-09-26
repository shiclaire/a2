#!/bin/bash
echo "update apt"
apt update >/dev/null 2>&1

echo "install nginx curl mysql-client"
apt install -y nginx curl mysql-client >/dev/null 2>&1
service nginx start

echo "install docker"

cd ~/
curl -fsSL get.docker.com -o get-docker.sh >/dev/null 2>&1
sh get-docker.sh
service docker start

curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir wordpressOld && cd wordpressOld
wget https://raw.githubusercontent.com/LiLoveShi/OMGOMGOMG/wordpressOld/docker-compose.yml
cd ~

mkdir wordpressNew && cd wordpressNew
wget https://raw.githubusercontent.com/LiLoveShi/OMGOMGOMG/wordpressNew/docker-compose.yml
cd ~

mkdir mysql && cd mysql
wget https://raw.githubusercontent.com/LiLoveShi/OMGOMGOMG/mysql/docker-compose.yml
cd ~

mkdir nginx && cd nginx
wget https://raw.githubusercontent.com/LiLoveShi/OMGOMGOMG/master/wp1
wget https://raw.githubusercontent.com/LiLoveShi/OMGOMGOMG/master/wp2
cd ~

sudo gpasswd -a ubuntu docker
sudo su
su ubuntu

docker-compose -f mysql/docker-compose.yml up -d

docker-compose -f wordpressOld/docker-compose.yml up -d

rm /etc/nginx/sites-enabled/*
cp nginx/wp1 /etc/nginx/sites-enabled/
service nginx reload


# echo "WOW, create a account"

# SITENAME=`curl ifconfig.co`

# wp_install_result=$(php -r 'define("WP_SITEURL", "http://'$SITENAME'");define("WP_INSTALLING", true);require_once("./wp-load.php");require_once("wp-admin/includes/upgrade.php");$response=wp_install("Hi Eva, I am Frank, To do this is very hard...OMG", admin, "OMG@qq.com", false, null, "ABC");echo $response;')
