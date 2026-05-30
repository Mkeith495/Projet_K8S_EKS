#!/bin/bash

bdd_user=cpuser
bdd_password=cpsecret

apt update
#apt upgrade -y
apt install -y apache2 libapache2-mod-php php php-mysql mariadb-server git vim
systemctl restart apache2
rm -rf /var/www/html/*

cd /tmp
git clone https://gl.avalone-fr.com/anthony/codepostal.git
cp -r codepostal/php/www/* /var/www/html/

mysql < /tmp/codepostal/mysql/cp.sql
echo "create user '$bdd_user'@'localhost' identified by '$bdd_password';" | mysql
echo "grant all privileges on cp.* to '$bdd_user'@'localhost';" | mysql

# Création de variables d'environnements
export DB_HOST=localhost
export DB_NAME=cp
export DB_USER=$bdd_user
export DB_PASSWORD=$bdd_password
export DB_PORT=3306
# Enregistrement des variables d'environnements
echo "DB_HOST=$DB_HOST" >> /etc/environment
echo "DB_NAME=$DB_NAME" >> /etc/environment
echo "DB_USER=$DB_USER" >> /etc/environment
echo "DB_PASSWORD=$DB_PASSWORD" >> /etc/environment
echo "DB_PORT=$DB_PORT" >> /etc/environment
# Ajout au envvars d'apache2
echo "export DB_HOST=$DB_HOST" >> /etc/apache2/envvars
echo "export DB_NAME=$DB_NAME" >> /etc/apache2/envvars
echo "export DB_USER=$DB_USER" >> /etc/apache2/envvars
echo "export DB_PASSWORD=$DB_PASSWORD" >> /etc/apache2/envvars
echo "export DB_PORT=$DB_PORT" >> /etc/apache2/envvars
# Redémarrage du service Apache
systemctl restart apache2
