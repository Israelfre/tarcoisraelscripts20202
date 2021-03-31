#!/bin/bash

SUBNET=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
IMAGE=ami-042e8287309f5df03
SGID=$(aws ec2 create-security-group --description "Aplicacao Web" --group-name "aplicacaoweb" --output text)

CHAVE=$1
USUARIO=$2
SENHA=$3

cat<<EOF > mysqlserver.sh
#!/bin/bash
apt update
apt install -y mysql-server
sed -ri 's/^bind-address.*=.*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf 
systemctl restart mysql.service
mysql<<EOF 
CREATE DATABASE scripts;
CREATE USER '$USUARIO'@'%' IDENTIFIED BY '$SENHA';
GRANT ALL PRIVILEGES ON scripts.* TO '$USUARIO'@'%';
quit;
EOF

chmod +x mysqlserver.sh

aws ec2 authorize-security-group-ingress --group-name "aplicacaoweb" --port 22 --protocol tcp --cidr 138.99.95.10/32
aws ec2 authorize-security-group-ingress --group-name "aplicacaoweb" --port 80 --protocol tcp --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name "aplicacaoweb" --port 3306 --protocol tcp --source-group $SGID

echo "Criando Banco de Dados..."

Instancia1=$(aws ec2 run-instances --image-id $IMAGE --instance-type t2.micro --key-name "$CHAVE" --security-group-ids $SGID --subnet-id $SUBNET --user-data file://mysqlserver.sh)
IP1=$(aws ec2 describe-instances --query "Reservations[0].Instances[].PrivateIpAddress" --output text)

echo "IP Privado do banco de dados: $IP1"

echo "Criando Servidor de Aplicação..."

cat<<EOF > mysqlphpwp.sh
#!/bin/bash

apt update

apt-get install -y apache2 php-mysql php-curl libapache2-mod-php php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

cat<<FIM > /etc/apache2/sites-available/wordpress.conf
<Directory /var/www/html/wordpress/>
    AllowOverride All
</Directory>
FIM

a2enmod rewrite
a2ensite wordpress

curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch wordpress/.htaccess
cp -a wordpress/. /var/www/html/wordpress
systemctl restart apache2

BD=scripts
USER=alunoufc
PASSWORD=123scripts456
HOST=$IP1

cat<<FIM > wp-config.php

<?php 
define( 'DB_NAME', '$BD' );
define( 'DB_USER', '$USER' );
define( 'DB_PASSWORD', '$PASSWORD' );
define( 'DB_HOST', '$HOST' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

\$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
FIM

chown -R www-data:www-data /var/www/html/wordpress
find /var/www/html/wordpress/ -type d -exec chmod 750 {} \;
find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;
cp wp-config.php /var/www/html/wordpress/
systemctl restart apache2
EOF

chmod +x mysqlphpwp.sh

instancia2=$(aws ec2 run-instances --image-id $IMAGE --instance-type t2.micro --key-name "$CHAVE" --security-group-ids $SGID --subnet-id $SUBNET --user-data file://mysqlphpwp.sh)

IP2=$(aws ec2 describe-instances --query "Reservations[1].Instances[].PublicIpAddress" --output text)

echo "IP Publico de Servidor de Aplicacao: $IP2"

echo "Acesse http://$IP2/wordpress para finalizar a configuração."





