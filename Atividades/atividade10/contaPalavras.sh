#!/bin/bash
# Correção: 1,0
 
read -p "Informe o arquivo: " arquivo

declare -A vet

for i in `cat $arquivo | tr '[[:punct:]]' ' ' | tr '[[:upper:]]' '[[:lower:]]'`
do
	  let vet[$i]++

done

for i in `cat $arquivo | tr '[[:punct:]]' ' ' | tr ' ' '\n' | tr '[[:upper:]]' '[[:lower:]]' | sort | uniq`
do
	  echo "$i: ${vet[$i]}" >> palavras.txt

done

cat palavras.txt | awk '{ print $2 " " $1}' | sort -r | awk '{ print $2 " " $1}'

rm palavras.txt

