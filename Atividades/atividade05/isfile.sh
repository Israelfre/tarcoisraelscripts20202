#!/bin/bash

verifica=$1

if test -d $verifica
then
	echo "É um diretório"
fi
	if test -f $verifica
	then
		echo "É um arquivo"
	fi
		if test -r $verifica
		then
			echo "Tem permissão de leitura"
		fi
		if test -w $verifica
		then
			echo "Tem permissão de escrita"
		else
			echo "Não tem permissão de escrita"
		fi

