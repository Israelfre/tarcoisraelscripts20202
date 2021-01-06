#!/bin/bash

adc=$1
nome=$2
email=$3


if test ${adc} = 'adicionar' 
then
	echo "${nome}:${email}" >> usuarios.db
	echo "Contato adicionado com sucesso"

elif test ${adc} = 'listar' 
then
	cat usuarios.db

elif test ${adc} = 'remover'
then
	sed -i '/'${nome}'/d' usuarios.db
	echo "Contato Removido com sucesso"
fi



