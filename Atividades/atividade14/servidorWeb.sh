#!/bin/bash

SUBNET=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
IMAGE=ami-042e8287309f5df03
SGID=$(aws ec2 describe-security-groups --query "SecurityGroups[0].GroupId" --output text)
chave=$1

aws ec2 authorize-security-group-ingress --group-id $SGID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SGID --protocol tcp --port 22 --cidr 0.0.0.0/0


echo "Criando o servidor..."

Instacia=$(aws ec2 run-instances --image-id $IMAGE --instance-type "t2.micro" --key-name "$chave" --security-group-ids $SGID --subnet-id $SUBNET)
ip=$(aws ec2 describe-instances --instance-id $Instacia --query "Reservations[0].Instances[].PublicIpAddress" --output text)

echo "Acesse: https://$ip/" 
