#!/bin/bash

echo "Clinica Kipipa"
echo ""
echo -e "Iniciar Sessao"
read -p "Insira o nome do usuario: " opcao

if [ "$(getent passwd "$opcao" | cut -d: -f3)" -eq 1000 ]; then
    su "$opcao"
    cd ..
    cd users
    chmod +x login.sh
    ./login.sh
    ./admin.sh
 else
    if [ "$(getent passwd "$opcao" | cut -d: -f3)" -ge 1100 ] && [ "$(getent passwd "$opcao" | cut -d: -f3)" -le 1199 ]; then
        su "$opcao"
        cd ..
        cd users
        chmod +x login.sh
	./login.sh
        ./patient.sh
 else
     if [ "$(getent passwd "$opcao" | cut -d: -f3)" -ge 1001 ] && [ "$(getent passwd "$opcao" | cut -d: -f3)" -le 1099 ]; then
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
    
