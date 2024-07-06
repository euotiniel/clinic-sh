#!/bin/bash

diretorio_pai="$(dirname "$PWD")"
arquivo="$diretorio_pai/database/mortality.txt"
tempfile=$(mktemp)

if [ ! -f "$arquivo" ]; then
    echo "Erro: o arquivo $arquivo não existe."
    exit 1
fi

agora=$(date +%s)
limite=120

while IFS=';' read -r id nome genero data_nascimento identificacao data_obito especialidade gravidade status causa; do
    if [ -n "$id" ]; then
        # Extrai o timestamp da data de óbito (supondo que a data de óbito esteja na última coluna)
        timestamp_obito=$(date -d "$data_obito" +%s)
        final=$((agora - timestamp_obito))

        if [ "$final" -lt "$limite" ]; then
            echo "$id;$nome;$genero;$data_nascimento;$identificacao;$data_obito;$especialidade;$gravidade;$status;$causa" >> "$tempfile"
        else
            echo "Linha removida: $id;$nome;$genero;$data_nascimento;$identificacao;$data_obito;$especialidade;$gravidade;$status;$causa"
        fi
    fi

done < "$arquivo"

mv "$tempfile" "$arquivo"

echo "Processamento concluído."

    echo "1. Voltar"
    
    read -p "Escolha uma opção: " opcao

    case $opcao in
    
    1)
        clear
        cd ../users
        ./admin.sh
        ;;
    *)
        echo "Opção inválida. Por favor, escolha novamente."
        ;;
    esac




