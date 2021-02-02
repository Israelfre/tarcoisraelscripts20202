#!/bin/bash

menu() {
   
   echo "1 - Tempo Ligado"
   echo "2 - Kernel"
   echo "3 - Memória Virtual"
   echo "4 - CPU por núcleos"
   echo "5 - CPU por processos"
   echo "6 - Memória Física"
   echo "7 - Sair"
   read -p "Informe a opção: " OPCAO
   case $OPCAO in

      1) clear
	 uptime
	 read -p "Digite [enter] para retornar ao menu."     
         ;;
      2) clear
	 dmesg | tail -n 10
	 read -p "Digite [enter] para retornar ao menu."     
         ;;
      3) clear
	 vmstat 1 10
	 read -p "Digite [enter] para retornar ao menu."  
         ;;
      4) clear
	 mpstat -P ALL 1 5
	 read -p "Digite [enter] para retornar ao menu."
         ;;
      5) clear
	 pidstat 1 5
	 read -p "Digite [enter] para retornar ao menu."
         ;;
      6) clear
	 free -m
	 read -p "Digite [enter] para retornar ao menu."
         ;;
      7) exit 0
         ;;
      *)
	 echo "Digite [enter] e tente novamente."
	 read 
	 ;;
   esac
   
   clear
}

while true
do
   menu
done


