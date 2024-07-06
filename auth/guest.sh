#!/bin/bash

clear

function pay {
    echo "Valor a pagar 30.000 Kz"
    echo "1. Pagar"
    echo "2. Sair"
    read -p "Escolha uma opção: " opcao

    case $opcao in
        1)
            sed -i "s/^\($numero_usuario;$codigo_alfanumerico;[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;\)false;/\1true;/" "$arquivo"
            echo "Pagamento realizado com sucesso!"
            ;;
        2)
            ./login.sh
            ;;
        *)
            echo "Opção inválida. Por favor, escolha novamente."
            ;;
    esac
}

read -p "Digite o número de usuário: " numero_usuario
read -p "Digite o código alfanumérico: " codigo_alfanumerico

diretorio_pai="$(dirname "$PWD")"
arquivo="$diretorio_pai/database/exams_done.txt"

if [ ! -f "$arquivo" ]; then
    echo "Erro: O arquivo '$arquivo' não existe."
    exit 1
fi

linha=$(grep "^$numero_usuario;$codigo_alfanumerico;" "$arquivo")

if [ -n "$linha" ]; then
    if echo "$linha" | grep -q ';true;'; then
        echo "Seus Resultados:"
        echo "$linha" | tr ';' '\n'
    else
        pay

        linha_atualizada=$(grep "^$numero_usuario;$codigo_alfanumerico;" "$arquivo")
        echo "Seus Resultados Atualizados:"
        echo "$linha_atualizada" | tr ';' '\n'
    fi
else
    echo "Combinação de usuário $numero_usuario e código $codigo_alfanumerico não encontrada no arquivo."
fi

