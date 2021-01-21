#!/bin/bash
# Correção: 0,5

tempo=""
echo "Relatório de Latência."

for var in `cat $1`
do
	tempo="$tempo;$(ping -c10 $var | grep -E 'min/avg/max/mdev' | cut -f5 -d"/")ms $var"

	
done

tempo=$(echo $tempo | tr -s ';' '\n' | sort -n | sed '1d')

	t=$IFS
	IFS="\n"
	linha=$(echo $tempo | wc -l)
	tempo=$(echo $tempo | tr -s '\n' ';')
	IFS=$t

for variacao in `seq 1 1 $linha`
do
        IFS="\n"
        var1=$(echo $tempo | cut -f$variacao -d";" | cut -f2 -d" ")
        var2=$(echo $tempo | cut -f$variacao -d";" | cut -f1 -d" ")
        IFS=$t
        echo $var1 $var2
done
