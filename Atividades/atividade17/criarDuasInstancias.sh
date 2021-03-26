#!/bin/bash
# Correção: 0,0. Idêntico ao do Rodrigo Lima. Também não valerá presença.
SUBNET=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
IMAGE=ami-042e8287309f5df03
SGID=$(aws ec2 create-security-group --description "Aplicacao Web" --group-name "aplicacaoweb" --output text)

chave=$1
usuario=$2
senha=$3

cat<<EOF > mysqlserver.sh
#!/bin/bash
apt update
apt install -y mysql-server
sed -ri 's/^bind-address.*=.*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf 
systemctl restart mysql.service
mysql<<EOF 
CREATE DATABASE scripts;
CREATE USER '$usuario'@'%' IDENTIFIED BY '$senha';
GRANT ALL PRIVILEGES ON scripts.* TO '$usuario'@'%';
USE scripts;
CREATE TABLE teste01 ( teste1 INT);
quit;
EOF

cat<<EOF > mysqlclient.sh
#!/bin/bash
apt-get install mysql-client -y
cat<<EOF > ~/.my.cnf
[client]
user=$usuario
password=$senha
EOF

chmod +x mysqlserver.sh
chmod +x mysqlclient.sh

# Está idêntico ao do Rodrigo, até o IP 138.99.95.10/32 que ele usou.
aws ec2 authorize-security-group-ingress --group-name "aplicacaoweb" --port 22 --protocol tcp --cidr 138.99.95.10/32
aws ec2 authorize-security-group-ingress --group-name "aplicacaoweb" --port 80 --protocol tcp --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name "aplicacaoweb" --port 3306 --protocol tcp --source-group $SGID

Instancia1=$(aws ec2 run-instances --image-id $IMAGE --instance-type t2.micro --key-name "$chave" --security-group-ids $SGID --subnet-id $SUBNET --user-data file://mysqlserver.sh)
IP1=$(aws ec2 describe-instances --query "Reservations[0].Instances[].PrivateIpAddress" --output text)

echo "Criando Banco de Dados..."
echo "IP Privado do banco de dados: $IP1"

instancia2=$(aws ec2 run-instances --image-id $IMAGE --instance-type t2.micro --key-name "$chave" --security-group-ids $SGID --subnet-id $SUBNET --user-data file://mysqlclient.sh)
IP2=$(aws ec2 describe-instances --query "Reservations[1].Instances[].PublicIpAddress" --output text)

echo "Criando Servidor de Aplicação..."
echo "IP Publico de Servidor de Aplicacao: $IP2"
