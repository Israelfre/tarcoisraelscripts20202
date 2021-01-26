#!/bin/bash
# Correção: 0,5
FORMATO=$1
COR=$2
SEP=$3
TXT=$4

case $FORMATO in
  "sublinhado")
	  tput smul
	  ;;
  "negrito")
	  tput bold
	  ;;
  "reverso")
	  tput smso
          ;;	  
esac

tput setaf $COR

linha=`echo $SEP | cut -f1 -d','`
coluna=`echo $SEP | cut -f2 -d','`

tput cup $linha $coluna

echo $TXT
tput init

