#!/bin/bash

function consultar_exames {
			echo "Sucesso."
    			echo "1. Voltar"
   			echo "2. Sair"

   			read -p "Escolha uma opção: " caso

    			if [ "$caso" == "1" ]; then
       		 ./doctor.sh
    			fi
    			
    			if [ "$caso" == "2" ]; then
       		 ../main.sh
    			fi
		}

		function verificar_resultados {
		
			echo "Sucesso. "
			echo "1. Voltar"
   			echo "2. Sair"

   			read -p "Escolha uma opção: " caso

    			if [ "$caso" == "1" ]; then
       		 ./doctor.sh
    			fi
    			
    			if [ "$caso" == "2" ]; then
       		 ./main.sh
    			fi
		}
		
		function ver_pacientes {
		
			echo "Sucesso. "
			echo "1. Voltar"
   			echo "2. Sair"

   			read -p "Escolha uma opção: " caso

    			if [ "$caso" == "1" ]; then
       		 ./doctor.sh
    			fi
    			
    			if [ "$caso" == "2" ]; then
       		 ./main.sh
    			fi
		}
		
		function historico_pacientes {
		
			echo "Sucesso. "
			echo "1. Voltar"
   			echo "2. Sair"

   			read -p "Escolha uma opção: " caso

    			if [ "$caso" == "1" ]; then
       		 ./doctor.sh
    			fi
    			
    			if [ "$caso" == "2" ]; then
       		 ./main.sh
    			fi
		}
		
		
		
name=$(whoami)

clear
echo "MENU DOCTOR"
echo "------------"
echo " 
1. Consultar exames
2. Verificar resultados
3. Ver todos os pacientes
4. Historico de pacientes
5. Sair
"
echo ""

echo "Escolha uma das opcoes: "

echo ""

read option

echo ""

case $option in 
	
	1) 
		echo "Minhas Consultas "
		consultar_exames
		echo ""
		;;
	2) 
		echo "Meus Resultados"
		verificar_resultados 
		echo ""
		;;
	3) 
		echo "Meus Pacientes"
		ver_pacientes
		echo ""
		;;
	4) 
		echo "Historico de Pacientes"
		historico_pacientes
		echo ""
		;;
	5) 
		echo "5. "
		cd ..
		cd auth
		chmod +x login.sh
		./login.sh
		;;	
	*) 
		echo "Opcao nao disponivel, escolha um dos numeros apresentados!"
		echo ""
		;;	
esac

		
	
