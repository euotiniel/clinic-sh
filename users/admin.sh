#!/bin/bash

# Definindo o diretório de logs
logs="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)/logs"

# Função para registrar informações no log
log_info(){
   echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1" >> "$logs/system.log"
}

# Função para registrar erros no log
log_error(){
   echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $1" >> "$logs/error.log"
}
# Funcoes

usuario=$(whoami)
function addDoctor {
	clear
log_info "O usuário $usuario adicionou o Medico $opcao"

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
	clear
	
	log_info "O usuário $usuario acessou a lista dos Medicos"

    awk -F':' '$3 >= 1001 && $3 <= 1099 && $1 != "nobody" {print $5}' /etc/passwd | cut -d',' -f1
	
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
	clear
	log_info "O usuário $usuario apagou o Medico $opcao"
	
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
	clear
	log_info "O usuário $usuario fez limpeza no sistema"

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
    	 cd ..
    	 cd session
    	 ./auth.sh
    fi

}

function addEmployee {
	clear
log_info "O usuário $usuario adicionou o Funcionario $user"
    next_uid=1100

    while true; do
    echo "Insira o nome de usuário do Funcionário (ou 'q' para sair):"
    read user

    if [[ "$user" == "q" ]]; then
        break
    fi

    sudo adduser --uid $next_uid "$user"
    ((next_uid++))

    echo "Usuário '$user' adicionado com UID $next_uid."
    done
    
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

function listEmployee {
	clear
	log_info "O usuário $usuario acessou a lista de Funcionarios"
    awk -F':' '$3 >= 1100 && $3 <= 1199 && $1 != "nobody" {print $5}' /etc/passwd | cut -d',' -f1

  
    echo ""
    echo "1. Voltar"
    echo "2. Sair"
    
    read -p "Escolha uma opção: " caso

    if [ "$caso" == "1" ]; then
       	./admin.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 cd ..
    	 cd auth
    	 ./login.sh
    fi
}

function deleteEmployee {

clear
log_info "O usuário $usuario apagou o Funcionario $user"
    remove_user() {
    read user

    sudo deluser "$user"
    echo "Usuário '$user' removido."
}


    while true; do
    echo "Selecione uma opção:"
    echo "1. Remover usuário"
    echo "2. Voltar"
    echo "3. Sair"
   

    read -p "Escolha uma opção: " opcao

    case $opcao in
        1)
            remove_user
            ;;
        2)
            ./admin.sh
            ;;
        3)
            cd ..
    	    cd auth
    	   ./login.sh
            ;;
        *)
            echo "Opção inválida. Por favor, escolha novamente."
            ;;
    esac
done   
}

clear
echo "------------------"
echo "MENU ADMINISTRADOR"
echo "------------------"
usuario=$(whoami)
nome=$(finger $usuario | awk -F: '/Name/ {print $3}' | tr -d ' ')
echo "Bem vindo/a $nome"
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
		deleteEmployee
		;;	
	6) 
		
		listEmployee
		;;
		
	7) 	
		cd ..
		cd create
		chmod a+x filiates.sh
		./filiates.sh
		;;	
	8) 	
		cleanSystem
		;;	
	9) 	
		echo "LOGS"
		
		;;	
	10) 
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


