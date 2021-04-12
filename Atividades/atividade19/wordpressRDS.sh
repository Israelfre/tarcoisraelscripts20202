#!/bin/bash
# Correção: 0,5. 

SUBNET=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
SUBNET1=$(aws ec2 describe-subnets --query "Subnets[1].SubnetId" --output text)

IMAGE=ami-042e8287309f5df03
SGID=$(aws ec2 create-security-group --description "Aplicacao Web" --group-name "aplicacaoweb" --output text)
SUBNETRDS=$(aws rds create-db-subnet-group --db-subnet-group-name "aplicacaoweb" --db-subnet-group-description "Aplicacao web" --subnet-ids $SUBNET $SUBNET1)

RDSID=$(aws rds describe-db-subnet-groups --query "DBSubnetGroups[0].DBSubnetGroupName" --output text)

CHAVE=$1
USUARIO=$2
SENHA=$3

aws ec2 authorize-security-group-ingress --group-name "aplicacaoweb" --port 22 --protocol tcp --cidr 138.99.95.10/32
aws ec2 authorize-security-group-ingress --group-name "aplicacaoweb" --port 80 --protocol tcp --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name "aplicacaoweb" --port 3306 --protocol tcp --source-group $SGID

echo "Criando  instância de Banco de Dados no RDS..."

BDMSQL=$(aws rds create-db-instance --db-instance-identifier scripts --engine mysql --master-username $USUARIO --master-user-password $SENHA --allocated-storage 20 --no-publicly-accessible --db-subnet-group-name $RDSID --vpc-security-group-ids $SGID --db-instance-class db.t2.micro)
EndPoint=$(aws rds describe-db-instances --query "DBInstances[].Endpoint.Address" --output text)

# Correção: Você não espera nada ficar pronto? Não vai funcionar, pois a instância web irá tentar criar o banco, mas o RDS
# não estará pronto.

echo "Endpoint do RDS: $EndPoint"

cat<<EOF > mysqlphpwp.sh
#!/bin/bash

apt update

apt-get install mysql-client -y

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

BD=wordpress
USER=wordpress
PASSWORD=123blog456
HOST=$EndPoint

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

echo "Criando servidor de Aplicação..."

EC2=$(aws ec2 run-instances --image-id $IMAGE --instance-type t2.micro --key-name "$CHAVE" --security-group-ids $SGID --subnet-id $SUBNET --user-data file://mysqlphpwp.sh)
IP=$(aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress" --output text)

echo "IP Público do Servidor de Aplicação:$IP"
echo "Acesse http://$IP/wordpress"

