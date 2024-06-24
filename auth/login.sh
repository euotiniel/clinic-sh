#!/bin/bash

clear

echo "Clinica Kipipa"
echo ""
echo -e "Iniciar Sessao"
read -p "Insira o nome do usuario: " opcao

uid=$(getent passwd "$opcao" 2>/dev/null | cut -d: -f3)

if [ -n "$uid" ]; then
    if [ "$uid" -eq 1000 ]; then
        su "$opcao"
        cd ..
        cd users
        chmod +x login.sh
        ./login.sh
        ./admin.sh
    elif [ "$uid" -ge 1100 ] && [ "$uid" -le 1199 ]; then
        su "$opcao"
        cd ..
        cd users
        chmod +x login.sh
        ./login.sh
        ./patient.sh
    elif [ "$uid" -ge 1001 ] && [ "$uid" -le 1099 ]; then
        su "$opcao"
        cd ..
        cd users
        chmod +x login.sh
        ./login.sh
        ./doctor.sh
    else
        echo "Usuário $opcao não possui perfil adequado."
    fi
else
    echo "Usuário $opcao não existe!"
fi

echo -e "1. Tentar Novamente"
echo -e "2. Sair"
    
    read -p "Escolha uma opção: " caso

    if [ "$caso" == "1" ]; then
       	./login.sh
    fi
    if [ "$caso" == "2" ]; then
    	 exit
    fi
    
