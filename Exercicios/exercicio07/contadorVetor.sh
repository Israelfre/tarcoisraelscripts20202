#!/bin/bash
# Correção: 0,5

Num=()
ind=0

while [ true ]
do 
	read -p "Digite o numero no vetor, ou liste o tamanho: " recebe
	if test $recebe != "q"
	then
		num[$ind]=$recebe
		ind=$((ind+1))
			
		echo "Num adc com sucesso"
	elif test $recebe == "q"
	then
		echo "Tamanho do vetor é ${#num[@]}"
		break
	else
		echo "Comando não é reconhecido"
	fi
done
