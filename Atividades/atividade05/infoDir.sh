#!/bin/bash
# Correção: 1,0

dir=$1

if test -d $dir  
then
        echo "O diretorio $dir ocupa $(du -hsk $dir | sed 's/[[:space:]].*.*/ /') kilobytes e tem $(ls $dir | wc -l) itens."
else
	echo "$dir Não é um diretorio"
fi
