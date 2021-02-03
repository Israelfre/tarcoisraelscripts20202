#!/bin/bash
# Correção: 1,0

trap "echo 'Script  Encerrado';exit" 2

menu() {
	echo "1 - Tempo ligado"
	echo "2 - Últimas Mensagens do Kernel  "
	echo "3 - Memória Virtual" 
	echo "4 - Uso da CPU por núcleo"
	echo "5 - Uso da CPU por processos"	
	echo "6 - Uso da Memória Física"
   	echo " "
	read -p "Informe a opção: " OPCAO
}

tempo(){
        
	clear
	echo "Resultado do tempo"	
	uptime
	echo " " 

}    
kernel(){
         clear
	 echo "Kernel"
	 dmesg | tail -n 10
	 echo " "     
}
memoria(){
 	 clear
	 echo "Memoria"
	 vmstat 1 10
	 echo " "
}
CPUnucleo(){
	 clear
	 echo "CPU Nucleo" 
	 mpstat -P ALL 1 5
	 echo " "
}
CPUprocesso(){
	 clear
	 echo "CPU Processo"
	 pidstat 1 5
	 echo " "
}
MemoriaF(){
         clear
	 echo "Memoria Fisica"
	 free -m
	 echo " "
}
   
while true
do
   menu
	
	if [ $OPCAO -eq 1 ]
	then
		tempo
	
	elif [ $OPCAO -eq 2 ]
	then	
		kernel

	elif [ $OPCAO -eq 3 ]
	then
		memoria
	elif [ $OPCAO -eq 4 ]
        then
		CPUnucleo	
	
	elif [ $OPCAO -eq 5 ]
        then
		CPUprocesso

	elif [ $OPCAO -eq 6 ]
        then
		MemoriaF
	else
		echo "Opção Invalida"
	fi
done


