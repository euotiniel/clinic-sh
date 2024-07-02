#!/bin/bash

# LOGS

# Definindo o diretório de logs
logs="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)/logs"

# Função para registrar informações no log
log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1" >>"$logs/system.log"
}

# Função para registrar erros no log
log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $1" >>"$logs/error.log"
}

function delFiliates {
	clear

	echo "Qual grupo deseja apagar?"
	read nome

	
	if grep -q "^$nome:" /etc/group; then
   
        usuarios=$(getent group $nome | cut -d: -f4)

   
       for usuario in $usuarios; do
       sudo deluser $usuario $nome
    done

    
    sudo groupdel $nome
    echo "Grupo $nome foi removido com sucesso."
else
    echo "O grupo $nome não existe."
fi

echo ""
    echo ""
    echo "1. Voltar"
    echo "2. Sair"
    echo "3. Continuar"
    
    read -p "Escolha uma opção: " caso

    if [ "$caso" == "1" ]; then
        ./filiates.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 cd ..
    	 cd users
    	 ./admin.sh
    fi
    if [ "$caso" == "3" ]; then
    	 delFiliates
    fi
	
}

function createFiliates {
	clear
    next_uid=1200

next_uid=1200

while true; do
    echo "Insira o nome da Filial (ou 'q' para sair):"
    read user

    if [[ "$user" == "q" ]]; then
        break
    fi

    echo "Criando grupo com nome '$user' e UID $next_uid..."

    sudo addgroup --gid $next_uid "$user"

    if [ $? -eq 0 ]; then
        echo "Filial '$user' adicionada com UID $next_uid."
    else
        echo "Erro ao adicionar filial '$user'."
    fi

    ((next_uid++))
done

    
    
    echo ""
    echo "1. Voltar"
    echo "2. Sair"
    
    read -p "Escolha uma opção: " caso

    if [ "$caso" == "1" ]; then
        ./filiates.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 cd ..
    	 cd users
    	 ./admin.sh
    fi
	
}

function listFiliates {
clear
 awk -F':' '$3 >= 1200 && $1 != "nogroup" {print $1}' /etc/group
 
    echo ""
    echo "1. Voltar"
    echo "2. Sair"
    
    read -p "Escolha uma opção: " caso

    if [ "$caso" == "1" ]; then
        ./filiates.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 cd ..
    	 cd users
    	 ./admin.sh
    fi
}



clear
echo "Filiais Kipipa"
echo "------------------"
usuario=$(whoami)
nome=$(finger $usuario | awk -F: '/Name/ {print $3}' | tr -d ' ')
echo "Bem vindo/a $nome"

echo ""
echo "1. Ver Filiais"
echo "2. Criar Filiais"
echo "3. Eliminar Filiais"
echo "3. Entrar Filiais"
echo "4. Sair"
	
echo "Escolha uma das opcoes: "

echo ""

read option

echo ""

case $option in 
	
	1) 
		listFiliates	
		;;
	2) 
		createFiliates
		
		;;
	3) 
		delFiliates
		
		;;
	4) 
		cd ..
		cd users
		chmod a+x ./admin.sh
		./admin.sh
		;;
	
	*) 
		echo "Opcao nao disponivel, escolha um dos numeros apresentados!"
		echo ""
		;;	
esac

		
	





 
