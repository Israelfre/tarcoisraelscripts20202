#!/bin/bash

adicionar() {
	echo "$1:$2" >> hosts.db
}

remover() {
	sed -i "/$1/d" hosts.db
}

listar() {
	cat hosts.db
}

procurar() {
	cat hosts.db | grep $1 | cut -d':' -f2
}

reverso() {
	cat hosts.db | grep $1 | cut -d ':' -f 1
}

menu() {
   echo -e "1 [adicionar]\n2 [remover]\n3 [listar]\n4 [busca reversa]\n5 [procurar]"
   read -p "Insira a opção " OPCAO

   case $OPCAO in
   "1") read -p "Insira o nome do host" NOME
        read -p "Insira o ip do host" IP
        adicionar $NOME $IP
        ;;
   "2") read -p "Insira o nome do host que deseja remover" NOME
        remover $NOME
        ;;
   "3") listar
        exit 0
        ;;
   "4") read -p "Insira o ip do host que deseja ver o nome"  IP
        reverso $IP
        ;;
   "5") read -p "Insira o nome do host que deseja ver o ip" NOME
        procurar $NOME
        ;;
esac
}

while getopts "a:i:d:r:l" OPTVAR
do
	case "$OPTVAR" in
		a)
			host=$OPTARG
			;;
		i)
			ip=$OPTARG
			;;
		d)
			delHost=$OPTARG
			;;
		l)
			listar=`echo "listar"`
			;;
		r)	reverso=$OPTARG
			;;
	esac
done

if ! [ -z $host ]
then
	if ! [ -z $ip ]
	then
		adicionar $host $ip
	fi
elif ! [ -z $delHost ]
then
	remover $delHost
elif ! [ -z $listar ]
then
	listar
elif ! [ -z $reverso ]
then
	reverso $reverso
elif ! [ -z $1 ]
then
	procurar $1
else 
	menu
fi
