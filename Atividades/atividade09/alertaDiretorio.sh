#!/bin/bash
# Correção: 3,0

tempo=$1
diret=$2
OldArq=""
tempD=$(echo $diret | sed 's/\//\\\//g')

for var in `find "$diret" 2> /dev/null`
do
        if test -f ''$var''
	then
		OldArq="$OldArq;$(date -r ''$var'' +%d/%m/%y" "%H:%M:%S"|") $var"
	fi
done

OldArq=$(echo $OldArq | sed 's/^;//')

while true
do
	NewArq=""
	for var in `find "$diret" 2> /dev/null`
	do
		if test -f ''$var''
		then
			NewArq="$NewArq;$(date -r ''$var'' +%d/%m/%y" "%H:%M:%S"|") $var"
		fi
	done

	NewArq=$(echo $NewArq | sed 's/^;//')
	alterados=""
	removidos=""
	adicionado=""

	NOldArq=$(echo $OldArq | tr ';' '\n' | wc -l)
	NNewArq=$(echo $NewArq | tr ';' '\n' | wc -l)
	
	if test -z "$NewArq"
	then
		NNewArq=0
	fi

	if test -z "$OldArq"
	then
		NOldArq=0
	fi

	Nad=0

	for var in `seq 1 1 $NNewArq`
	do
		tempArq=$(echo $NewArq | cut -f$var -d';' | cut -f3- -d' ')
		if ! [ "$(echo $OldArq | tr ';' '\n' | grep $tempArq$ | cut -f3- -d' ')" = "$tempArq" ]
		then
			Nad=`expr $Nad + 1`
			adicionados=$adicionados" "$(echo "$(echo $tempArq | sed 's/'$tempD'//' | cut -f2- -d'/'), ")
		fi
	done

	if [ $Nad -gt 0 ]
	then
		adicionados="Adicionados: "$NOldArq"->"$Nad" "$(echo $adicionados | sed 's/[, ]$//')
		echo "$(date +"["%d/%m/%y" "%H:%M:%S"] ")Alteração! $adicionados"
		echo "$(date +"["%d/%m/%y" "%H:%M:%S"] ")Alteração! $adicionados" >> dirSensors.log
		adicionados=""
	fi

	Nrm=$NOldArq

	for var in `seq 1 1 $NOldArq`
	do
		tempArq=$(echo $OldArq | cut -f$var -d';' | cut -f3- -d' ')
		if ! [ "$(echo $NewArq | tr ';' '\n' | grep $tempArq$ | cut -f3- -d' ')" = "$tempArq" ]
		then
			Nrm=`expr $Nrm - 1`
			removidos=$removidos" "$(echo "$(echo $tempArq | sed 's/'$tempD'//' | cut -f2- -d'/'), ")
		fi
	done

	if [ "$Nrm" -ne "$NOldArq" ]
	then
		removidos="Removidos: "$NOldArq"->"$Nrm" "$(echo $removidos | sed 's/[, ]$//')
		echo "$(date +"["%d/%m/%y" "%H:%M:%S"] ")Alteração! $removidos"
		echo "$(date +"["%d/%m/%y" "%H:%M:%S"] ")Alteração! $removidos" >> dirSensors.log
		removidos=""
	fi

	for var in `seq 1 1 $NNewArq`
	do
		tempArq=$(echo $NewArq | cut -f$var -d';' | cut -f3- -d' ')
		gre=$(echo $OldArq | tr ';' '\n' | grep -E $tempArq$ | wc -l)
		gre1=$(echo $OldArq | tr ';' '\n' | grep -E $tempArq$ | cut -f1 -d'|')
		gre2=$(echo $NewArq | cut -f$var -d';' | cut -f1 -d'|')
		if [ $gre -ne 0 ]
		then
			if [ "$(echo $OldArq | tr ';' '\n' | grep -E $tempArq$ | cut -f3- -d' ')" = "$tempArq" ]
			then
				if ! [ "$gre1" = "$gre2" ]
				then
					alterados=$alterados" "$(echo "$(echo $tempArq | sed 's/'$tempD'//' | cut -f2- -d'/'), ")
				fi
			fi
		fi
	done

	alterados="Alterados: "$(echo $alterados | sed 's/[, ]$//')

	if ! [ "Alterados: " = "$alterados" ]
	then
		echo "$(date +"["%d/%m/%y" "%H:%M:%S"] ")Alteração! $alterados"
		echo "$(date +"["%d/%m/%y" "%H:%M:%S"] ")Alteração! $alterados" >> dirSensors.log
	fi

	OldArq=$NewArq
	sleep $tempo
done
