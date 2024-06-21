#!/bin/bash

echo "Clinica Kipipa"
echo ""
echo -e "Iniciar Sessao"
echo "Insira o nome do usuario"
read opcao

if [ "$(getent passwd "$opcao" | cut -d: -f3)" -eq 1000 ]; then
    su "$opcao"
    cd ..
    cd users
    chmod +x login.sh
    ./login.sh
    ./admin.sh
else
    if getent passwd "$opcao" > /dev/null; then
        su "$opcao"
        cd ..
        cd users
        chmod +x login.sh
	./login.sh
        ./doctor.sh
else
        echo "Usuário $opcao não existe!"
    fi
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
    
