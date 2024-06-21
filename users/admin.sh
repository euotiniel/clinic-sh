#!/bin/bash




function addDoctor {

    echo "Insira o nome de usuario do Medico"
    read user 

    sudo adduser $user
    echo "Medico adicionado com Sucesso!"
    
    read  caso
    echo "1. Voltar"
    echo "2. Sair"
    read -p "Escolha uma opção: " caso
    if [ "$caso" == "1" ]; then
       	./admin.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 exit
    fi

}

function listDoctor {

    awk -F':' '$3 >= 1002 && $1 != "nobody" {print $5}' /etc/passwd | cut -d',' -f1
	
    echo ""
    echo "1. Voltar"
    echo "2. Sair"
    
    read -p "Escolha uma opção: " caso

    if [ "$caso" == "1" ]; then
       	./admin.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 exit
    fi
}


function deleteDoctor {
	
    echo "Qual Medico pretende deletar?"
    read opcao
    
   if getent passwd "$opcao" > /dev/null; then
   sudo deluser "$opcao"
   else
   echo "Usuário $opcao não existe!"
   fi
	
    echo ""	
    echo "1. Voltar"
    echo "2. Sair"
    echo "3. Continuar"
    
    read -p "Escolha uma opção: " caso

    if [ "$caso" == "1" ]; then
       	./admin.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 exit
    fi
    
    if [ "$caso" == "3" ]; then
    	 deleteDoctor
    fi
}

function cleanSystem {

    sudo apt-get autoremove
    sudo apt-get autoclean
    sudo apt-get clean

    echo ""	
    echo "1. Voltar"
    echo "2. Sair"
    
    read -p "Escolha uma opção: " caso

    if [ "$caso" == "1" ]; then
       	./admin.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 exit
    fi

}

function addEmployee {

    echo "Insira o nome de usuario do Funcionario"
    read user 

    sudo adduser -u 1100 "$user"
    echo "Funcionario adicionado com Sucesso!"
    
    read  caso
    echo "1. Voltar"
    echo "2. Sair"
    read -p "Escolha uma opção: " caso
    if [ "$caso" == "1" ]; then
       	./admin.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 exit
    fi

}

clear
echo "MENU ADMIN"
echo "--------------"
echo ""
echo " 
1. Adicionar Medicos
2. Eliminar Medicos
3. Listar Medicos
4. Adicionar Funcionarios
5. Eliminar Funcionarios
6. Listar Funcionarios
7. Filias
8. Limpeza do Sistema
9. Logs
10. Sair
"
echo ""

read option

echo ""

case $option in 
	
	1) 	
		addDoctor
		;;
	2) 
		deleteDoctor
		;;
	3) 
		listDoctor 
		;;
	4) 
		addEmployee 
		;;
		
	5) 	
		cleanSystem
		;;	
	6) 
		
		;;
		4) 
		scheduleExams
		;;
		
	7) 	
		cleanSystem
		;;	
	8) 	
		cleanSystem
		;;	
	9) 
		
		;;	
	10) 
		cd ..
		cd session
		chmod +x auth.sh
		./auth.sh
		;;	
	*) 
		echo "Opcao nao disponivel, escolha um dos numeros apresentados!"
		echo ""
		;;
esac
