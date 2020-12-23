#!/bin/bash
# Correção: 1,0
adc=$1
nome=$2
email=$3

if test ${adc} = 'adicionar' 
then
	echo "${nome}:${email}" >> usuarios.db
	echo "Contato ${nome} adicionado com sucesso"
fi

if test ${adc} = 'listar' 
then
	cat usuarios.db
fi


