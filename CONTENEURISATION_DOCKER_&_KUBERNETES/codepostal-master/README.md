# Code postaux de France
Cette application permet de rechercher un code postal à partir du nom de la ville et le nom de la ville en fonction du code postal.

## Fonctionnement
### Avec Docker
```shell
git clone https://gl.avalone-fr.com/anthony/codepostal.git
cd codepostal
docker compose up -d
```
Connectez-vous à l'adresse http://localhost:8080/ pour accéder à l'application.

### Sans Docker
- Installez un serveur MySQL et intégrez la base de données à partir du fichier `mysql/cp.sql`.
- Installez un serveur Web (Apache / NGinx) ainsi que PHP en version 7 ou plus.
- Installez l'extension pdo mysql pour php.
- Configurez la connexion à la base de données en modifiant le fichier `php/www/connect.php` ou en mettant en place des variables d'environnement.

Exemple :
```shell
# Clonage du dépôt
git clone https://gl.avalone-fr.com/anthony/codepostal.git
cd codepostal

# Installation des composants
apt update && apt install mysql-server apache2 libapache2-mod-php php-mysql
# Intégration de la base de données
mysql < mysql/cp.sql
# Création d'utilisateur MySQL avec mot de passe pour l'accès à la base de données
mysql <<EOF
create user cp@'localhost' identified by 'secret';
grant all privileges on cp.* to cp@'localhost';
EOF

# Copie des fichiers de l'application dans l'arborescence Web
rm /var/www/html/index.html
cp -r php/www/* /var/www/html/

# Configuration des variables d'environnement
echo 'export DB_HOST="localhost"' >> /etc/apache2/envvars
echo 'export DB_NAME="cp"' >> /etc/apache2/envvars
echo 'export DB_USER="cp"' >> /etc/apache2/envvars
echo 'export DB_PASSWORD="secret"' >> /etc/apache2/envvars
echo 'export DB_PORT="3306"' >> /etc/apache2/envvars

# Redémarrage d'Apache
systemctl restart apache2.service

```