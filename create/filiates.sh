#!/bin/bash

echo "Filiais Kipipa"
echo ""


function delFiliates {

	echo "Qual Filial deseja apagar?!"
	read nome
	
	usuarios=$(getent group $nome | cut -d: -f4)
	for usuario in $usuarios; do
        deluser $usuario $nome
        done
	groupdel $grupo
	
}

function createFiliates {
	
    next_uid=1200

    while true; do
    echo "Insira o nome de usuário da Filial (ou 'q' para sair):"
    read user

    if [[ "$user" == "q" ]]; then
        break
    fi

    sudo addgroup --uid $next_uid "$user"
    ((next_uid++))

    echo "Filial '$user' adicionado com UID ."
    done
	
}

function filiates {


	echo "1. Ver Filiais"
	echo "2. Eliminar Filiais"
	echo "3. Entrar Filiais"
	

	: <<'COMMENT'
	echo "Escolha o nome da Filial"
	read nome
	sudo addgroup $nome --force-badname

	echo ""
	echo "1. Voltar"
e	cho "2. Sair"

r	ead -p "Escolha uma opção: " caso

i	f [ "$caso" == "1" ]; then
    .	/admin.sh
	fi

	if [ "$caso" == "2" ]; then
    	cd ..
    	cd session
    	./auth.sh
fi
COMMENT
 
}
