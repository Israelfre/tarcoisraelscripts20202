#!/bin/bash

adc=${0}
nome=${1}
email=${2}

if [ ${adc} = 'adicionar' ]
then
	echo "${nome}:${email}" >> usuarios.db
	echo "Contato ${nome} adicionado com sucesso"
fi
if [ ${adc} = 'listar' ]
then
	cat usuarios.db
fi


