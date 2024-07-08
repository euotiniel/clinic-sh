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

clear
figlet "Clinica Santa Muxima"
echo ""
echo "LOGIN"
read -p "Insira o nome do usuário: " opcao


echo ""

uid=$(getent passwd "$opcao" 2>/dev/null | cut -d: -f3)

if [ -n "$opcao" ]; then
    if [ "$opcao" = "guest" ]; then
        log_info "O usuário $opcao iniciou sessão como convidado"
        cd ../auth
        ./guest.sh
    elif id -u "$opcao" >/dev/null 2>&1; then
            if [ "$uid" -eq 1000 ]; then
                log_info "O usuário $opcao iniciou sessão como administrador"
                su "$opcao"
                cd ../users
                chmod +x login.sh
                ./login.sh
                ./admin.sh
            elif [ "$uid" -ge 1100 ] && [ "$uid" -le 1199 ]; then
                log_info "O usuário $opcao iniciou sessão como paciente"
                su "$opcao"
                cd ../users
                chmod +x login.sh
                ./login.sh
                ./patient.sh
            elif [ "$uid" -ge 1001 ] && [ "$uid" -le 1099 ]; then
                log_info "O usuário $opcao iniciou sessão como médico"
                su "$opcao"
                cd ../users
                chmod +x login.sh
                ./login.sh
                ./doctor.sh
            else
                echo "Usuário $opcao não possui perfil adequado."
                log_error "O usuário $opcao não possui perfil adequado"
            fi
      
    else
        echo "Usuário $opcao não existe!"
        log_error "O usuário $opcao não existe"
    fi
else
    echo "Nome de usuário não especificado!"
    log_error "Nome de usuário não especificado"
fi


# Opções para tentar novamente ou sair
echo -e "1. Tentar Novamente"
echo -e "2. Sair"

read -p "Escolha uma opção: " caso

if [ "$caso" == "1" ]; then
    ./login.sh
elif [ "$caso" == "2" ]; then
    exit
fi

