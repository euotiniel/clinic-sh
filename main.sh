#!/bin/bash


if command -v finger &>/dev/null; then
    echo " "
else
    echo "Instalando o pacote 'finger'..."
    sudo apt update &>/dev/null

    sudo apt install finger -y &>/dev/null

    if [ $? -eq 0 ]; then
        echo "Finger instalado com sucesso!"
    else
        echo "Houve um problema ao instalar o comando 'finger'."
        exit 1
    fi
fi

if command -v nfs &>/dev/null; then
    echo " "
else
    echo "Instalando o pacote 'nfs-common'..."
    sudo apt update &>/dev/null

    sudo apt install nfs-common -y &>/dev/null

    if [ $? -eq 0 ]; then
        echo "NFS instalado com sucesso!"
    else
        echo "Houve um problema ao instalar o pacote 'nfs-common'."
        exit 1
    fi
fi

cd auth
chmod a+x login.sh
./login.sh
