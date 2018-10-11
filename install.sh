#!/bin/bash


password="wpass1"
dbname=wordpress
adminuser=admin
adminpass=password
adminemail=example@example.com
sitetitle=Example
for i in "$@"
do
case $i in
    -d=*|--dbpass=*)
    password="${i#*=}"
    shift # past argument=value
    ;;
    -n=*|--dbname=*)
    dbname="${i#*=}"
    shift # past argument=value
    ;;
    -u=*|--userwp=*)
    adminuser="${i#*=}"
    shift # past argument=value
    ;;
    -p=*|--passwordwp=*)
    adminpass="${i#*=}"
    shift # past argument=value
    ;;
    -u=*|--emailwp=*)
    adminemail="${i#*=}"
    shift # past argument=value
    ;;
    -t=*|--sitetitle=*)
    sitetitle="${i#*=}"
    shift # past argument=value
    ;;
    *)
    echo "Running default configuration."      # unknown option
    ;;
esac
done

echo "$password"
echo "$dbname"
echo "$adminuser"
echo "$adminpass"
echo "$adminemail"
echo "$sitetitle"

#update before install
apt update -y

#1 Install Apache
apt-get install apache2 -y

#check syntax warnings
apache2ctl configtest

#Adjust the Firewall to Allow Web Traffic
ufw allow in "Apache Full"

#2 Install MySQL

sudo apt-get -y install mysql-server-5.7

echo "Please enter the database password you set: "
read -s password


#3 Install PHP
apt-get install php libapache2-mod-php php-mcrypt php-mysql -y
systemctl restart apache2


#Install PHP module cli..
apt-get install php-cli -y


#Step 1: Create a MySQL Database and User for WordPress

# IP for signing in

echo "match IP,username,port"

hostname=localhost

username=root

port=3306

echo "Authenticating database credentials..."
LOGIN_CMD="mysql -h ${hostname} -P ${port} -u ${username} --password=${password}"

{
	echo LOGIN_CMD
} 2> /dev/null



#Create Database

echo "Creating database ${dbname}"

create_db_sql="create database if not exists ${dbname} character set utf8 collate utf8_unicode_ci"

{
echo ${create_db_sql} | ${LOGIN_CMD} 
} 2> /dev/null

if [ $? -ne 0 ]
then
	echo "create database ${DBNAME} failed..."
	exit 1
else
    echo "succeed to create database ${DBNAME}"
fi

#Step 2: Install Additional PHP Extensions

echo "Downloading php extensions..."

apt-get -y install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc

echo "Restarting Apache for extensions..."

systemctl apache2 restart


#Step 3: Adjust Apache's Configuration to Allow for .htaccess Overrides and Rewrites

echo "Enabling .htaccess Overrides..."

echo "<Directory /var/www/html/>

    AllowOverride All

</Directory>
" >> /etc/apache2/apache2.conf

echo "Enabling the Rewrite Module..."
a2enmod rewrite

echo "Checking Changes..."
apache2ctl configtest

echo "Restarting Apache to reflect changes..."
systemctl apache2 restart


echo "Downloading Wordpress"

mkdir temp
cd temp
curl -O https://wordpress.org/latest.tar.gz

tar -zxvf latest.tar.gz


#create wp config
cp -a wordpress/. /var/www/html

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php


#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" /var/www/html/wp-config.php

perl -pi -e "s/username_here/$username/g" /var/www/html/wp-config.php

perl -pi -e "s/password_here/$password/g" /var/www/html/wp-config.php



#salts

perl -i -pe'

  BEGIN {

    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);

    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";

    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }

  }

  s/put your unique phrase here/salt()/ge

' /var/www/html/wp-config.php


chown ubuntu:www-data  -R /var/www/html/* 
find /var/www/html/ -type d -exec chmod 755 {} \;  # Change directory permissions rwxr-xr-x
find /var/www/html/ -type f -exec chmod 644 {} \;

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar

mv wp-cli.phar /usr/local/bin/wp
cd ..
rm -rf temp
mv /var/www/html/index.html /var/www/html/apachedefault.html

ipurl="$(curl ipinfo.io/ip --max-time 8)"  #get the external IP
siteurl=${ipurl}
echo $siteurl


sudo -u ubuntu -i -- wp core install --url=${siteurl} --title="${sitetitle}" --admin_user=${adminuser} --admin_password=${adminpass} --path=/var/www/html --admin_email="${adminemail}"
exit
