#!/bin/bash

source ../config.sh 

# Sets

database_dir="$PROJECT_URL/database"

patients_consulta_db="$database_dir/patients_consulta_marc.txt"

patients_exame_db="$database_dir/patients_exame_marc.txt"

if [ ! -f "$patients_consulta_db" ]; then
	touch "$patients_consulta_db"
fi

if [ ! -f "$patients_exame_db" ]; then
	touch "$patients_exame_db"
fi

# Functions

function makeMarking {
    clear
    echo -e "FAZER MARCACOES"
    echo ""
    echo -e "Digite os dados do paciente:"
    echo ""
    echo -e "Nome: "
    read name
    echo -e "Data de nascimento (ddmmaaaa): "
    read birth
    echo -e "Telefone: "
    read phone
    echo -e "Dia da consulta (ddmmaaaa): "
    read consultationDay
    echo -e "Area da consulta: "
    echo "
1 - Fisioterapia:
2 - Dermatologia 
3 - Genecologia
    "
    read area
    
    # Salvar os dados em um arquivo de texto e verificar o sucesso
    
    file="$PROJECT_URL/database/patients_consulta_marc.txt"
    
    id=$(wc -l < "$file")
    
    id=$((id + 1))
    
    if echo "$id;$name;$birth;$phone;$consultationDay;$area" >> "$file"; then
      
        echo ""
        echo "Marcação feita com sucesso!"
    else
        echo ""
        echo "Erro ao salvar a marcação. Verifique as permissões ou tente novamente."
    fi
    
    echo ""
    echo -e "1. Voltar"
    echo ""
    
    while true; do
    	read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
    	    ./patient.sh
    	    break  
        fi
    done
}

function consultMarking {
    clear
    echo ""
    echo -e "CONSULTAR MARCACOES"
    echo ""

    # Verifica se o arquivo existe
    file="$PROJECT_URL/database/patients_consulta_marc.txt"
    
    if [ ! -f "$file" ]; then
        echo -e "Lista de marcacoes vazia."
        echo ""
        echo -e "1. Voltar"
        echo ""
    
        while true; do
            read -p "Digite 1 para voltar: " caso

            if [ "$caso" == "1" ]; then
                ./patient.sh
                break  
            fi
        done
    fi

    # Exibir as marcações existentes
    echo -e "Lista de Marcacoes:"
    echo ""
    while IFS=';' read -r id name birth phone consultationDay area; do
        echo "Id: $id"
        echo "Nome: $name"
        echo "Data de Nascimento: $birth"
        echo "Telefone: $phone"
        echo "Dia da Consulta: $consultationDay"
        echo "Area consulta: $area"
        echo "-------------------"
    done < "$file"
    
    echo ""
    echo -e "1. Voltar"
    echo ""
    
    while true; do
        read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
        	./patient.sh
                break  
        fi
    done
}



function scheduleExams {
	clear
    echo ""
    echo -e "MARCAR EXAME"
    echo ""
    echo -e "Digite os dados do paciente:"
    echo ""
    echo -e "Id da consulta: "
    read search_id
    
    # Salvar os dados em um arquivo de texto e verificar o sucesso
    
    file="$PROJECT_URL/database/patients_consulta_marc.txt"
    
    found=false
    
    while IFS=';' read -r id name birth phone consultationDay area; do
        if [ "$id" == "$search_id" ]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area consulta: $area"
            echo "-------------------"
            found=true
            
           subFunctionScheduleExam "$name" "$birth" "$phone" "$consultationDay" "$area"
         # Criar um arquivo temporário sem o registro correspondente ao search_id
        temp_file=$(mktemp)

        grep -v "^$search_id;" "$file" > "$temp_file"
        
        # Verificar se o arquivo temporário foi criado com sucesso
        if [ -f "$temp_file" ]; then
            # Substituir o arquivo original com o arquivo temporário
            if mv "$temp_file" "$file"; then
                echo "Registro com ID $search_id removido com sucesso."
            else
                echo "Erro ao remover o registro com ID $search_id."
            fi
        else
            echo "Erro: arquivo temporário não encontrado."
        fi

        break
    fi		
    done < "$file"
    
    if ! $found; then
        echo "Nenhum registro encontrado com o ID $search_id."
        echo ""
        
        file="$PROJECT_URL/database/patients_exame_marc.txt"
            
        echo -e "Digite os dados do paciente:"
    	echo ""
    	echo -e "Nome: "
    	read name
    	echo -e "Data de nascimento (ddmmaaaa): "
    	read birth
    	echo -e "Telefone: "
    	read phone
    	echo -e "Dia do exame (ddmmaaaa): "
    	read consultationDay
    	echo -e "Area da consulta: "
    	echo "
1 - Fisioterapia:
2 - Dermatologia 
3 - Genecologia
"
    read area
    
            subFunctionScheduleExam "$name" "$birth" "$phone" "$consultationDay" "$area"
    fi
    
    # Salvar os dados em um arquivo de texto e verificar o sucesso
    
    file="$PROJECT_URL/database/patients_exame_marc.txt"
    
    id=$(wc -l < "$file")
    
    id=$((id + 1))
    
    if echo "$id;$name;$birth;$phone;$consultationDay;$area" >> "$file"; then
        echo ""
        echo "Marcação de exame feita com sucesso!"
    else
        echo ""
        echo "Erro ao salvar a marcação de exame. Verifique as permissões ou tente novamente."
    fi
    
    echo ""
    echo -e "1. Voltar"
    echo ""
    
    while true; do
        read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
        	./patient.sh
                break  
        fi
    done
}

function checkExams {
    clear
    echo ""
    echo -e "CONSULTAR MARCACOES DE EXAMES"
    echo ""

    # Verifica se o arquivo existe
    file="$PROJECT_URL/database/patients_exame_marc.txt"
    
    if [ ! -s "$file" ]; then
        echo -e "Nenhuma marcao de exame."
        echo ""
        echo -e "1. Voltar"
        echo ""
    
        while true; do
            read -p "Digite 1 para voltar: " caso

            if [ "$caso" == "1" ]; then
                ./patient.sh
                break  
            fi
        done
    fi

    # Exibir as marcações existentes
    echo -e "Marcacoes para exames:"
    echo ""
    while IFS=';' read -r id name birth phone consultationDay area; do
        echo "Id: $id"
        echo "Nome: $name"
        echo "Data de Nascimento: $birth"
        echo "Telefone: $phone"
        echo "Dia da Consulta: $consultationDay"
        echo "Area consulta: $area"
        echo "-------------------"
    done < "$file"
    
    echo ""
    echo -e "1. Voltar"
    echo ""
    
    while true; do
        read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
        	./patient.sh
                break  
        fi
    done
}

function subFunctionScheduleExam {   
    # Atribuir parâmetros a variáveis locais
    name="$name"
    birth="$birth"
    phone="$phone"
    consultationDay="$consultationDay"
    area="$area"
    
    file="$PROJECT_URL/database/patients_exame_marc.txt"
    
    id=$(wc -l < "$file")
    
    id=$((id + 1))
    
    if echo "$id;$name;$birth;$phone;$consultationDay;$area" >> "$file"; then
      
        echo ""
        echo "Exame feito com sucesso!"
    else
        echo ""
        echo "Ups! Erro ao salvar. Verifique as permissões ou tente novamente."
    fi
    
    echo ""
    echo -e "1. Voltar"
    while true; do
    	read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
    	    exit
    	    break  
        fi
    done
}

# Main

name=$(whoami)

clear
echo "MENU PACIENTE"
echo "--------------"
echo " 
1. Fazer marcacao
2. Consultar marcacoes
3. Marcar exames
4. Consultar exames
5. Sair
"

echo "Escolha uma das opcoes: "

echo ""

read option

echo ""

case $option in 
	
	1) 	
		makeMarking
		;;
	2) 
		consultMarking
		;;
	3) 
		scheduleExams
		;;
	4) 
		checkExams
		;;
	5) 
		cd ..
		cd session
		chmod +x auth.sh
		./auth.sh
		;;	
	*) 
		echo "Opcao nao disponivel, escolha um dos numeros apresentados!"
		echo ""
		;;	
esac	
