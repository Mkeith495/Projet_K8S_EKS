#!/bin/bash

cp_server_ip=$1
bdd_user=$2
bdd_password=$3

apt update
apt upgrade -y
apt install -y mariadb-server git vim

cd /tmp
git clone https://gl.avalone-fr.com/anthony/codepostal.git
mysql < /tmp/codepostal/mysql/cp.sql
echo "create user '$bdd_user'@'$cp_server_ip' identified by '$bdd_password';" | mysql
echo "grant all privileges on cp.* to '$bdd_user'@'$cp_server_ip';" | mysql

# Autorisation de la connexion à la base de données depuis l'extérieur
sed -i "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb
