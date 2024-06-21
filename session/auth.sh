#!/bin/bash

echo "=== Menu de Sessão ==="
echo "Bem Vindo"
echo ""
echo "Iniciar Sessao"
echo "Insira o nome do usuario"
read opcao

if [ "$(getent passwd "$opcao" | cut -d: -f3)" -eq 1000 ]; then
    su "$opcao"
    cd .. 
    cd users
    chmod +x auth.sh
    ./auth.sh
    ./admin.sh
else
    
    if  getent passwd "$opcao" > /dev/null; then
        su "$opcao"
        cd ..
        cd users
        chmod +x auth.sh
	./auth.sh
        ./doctor.sh
    else
        echo "Usuário $opcao não existe!"
    fi
fi
  
   echo ""
   echo "1. Tentar Novamente"
   echo "2. Sair"  
  
   read -p "Escolha uma opção: " caso
   

   if [ "$caso" == "1" ]; then
       	./auth.sh
    fi
   if [ "$caso" == "2" ]; then
    	 cd ..
    	 cd session
    	 ./auth.sh
    fi
    
    
    
    
    
    
    
    
    	 exit
    fi
    
