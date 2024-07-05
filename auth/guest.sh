
#!/bin/bash

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
    echo "Seus Resultados"
    echo "$linha" | tr ';' '\n'
else
    echo "Combinação de usuário $numero_usuario e código $codigo_alfanumerico não encontrada no arquivo."
fi

