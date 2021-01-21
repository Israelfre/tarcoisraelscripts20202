#!/bin/bash
# Correção: 1,0

num1=$1
num2=$2
num3=$3

if [[ $num1 = ?+([A-Za-z]) ]]
then
        echo "Opa!! $num1 não é número."

        elif [[ $num2 = ?+([A-Za-z]) ]]
        then
                echo "Opa!! $num2 não é número."

        elif [[ $num3 = ?+([A-Za-z]) ]]
        then
                echo "Opa!! $num3 não é número."


	elif test $num1 -ge $num2 && test $num1 -ge $num3
	then
        	echo "$num1"

		elif test $num2 -ge $num1 && test $num2 -ge $num3
		then
        		echo "$num2"

		elif test $num3 -ge $num1 && test $num3 -ge $num2
		then
	      		echo "$num3"
		fi

