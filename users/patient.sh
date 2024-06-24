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
    echo -e "FAZER MARCAÇÕES"
    echo ""
    echo -e "Digite os dados do paciente:"
    echo ""

    while true; do
        read -p "Nome: " name
        if [[ -z "$name" ]]; then
            echo "Nome não pode estar vazio. Por favor, digite novamente."
        else
            break
        fi
    done
    
    while true; do
    read -p "Gênero (M ou F): " gender

    if [[ "$gender" == "M" || "$gender" == "m" ]]; then
        gender="M"
        break
    elif [[ "$gender" == "F" || "$gender" == "f" ]]; then
        gender="F"
        break
    else
        echo "Opção inválida. Escolha M para masculino ou F para feminino."
    fi
done


    while true; do
        read -p "Data de nascimento (ddmmaaaa): " birth
        if [[ ! "$birth" =~ ^[0-9]{8}$ ]]; then
            echo "Formato inválido. Use o formato ddmmaaaa (8 dígitos)."
        else
            birth_formatted=$(echo "$birth" | sed 's/\(..\)\(..\)\(....\)/\1-\2-\3/')
            echo "$birth_formatted"
            birth=$birth_formatted
            break
        fi
    done

    while true; do
        read -p "Telefone: " phone
        if [[ ! "$phone" =~ ^[0-9]{9,13}$ ]]; then
            echo "Telefone inválido. Deve conter entre 9 e 13 (+244) dígitos numéricos."
        else
            break
        fi
    done

    while true; do
        read -p "Dia da consulta (ddmmaaaa): " consultationDay
        if [[ ! "$consultationDay" =~ ^[0-9]{8}$ ]]; then
            echo "Formato inválido. Use o formato ddmmaaaa (8 dígitos)."
        else
            formatted=$(echo "$consultationDay" | sed 's/\(..\)\(..\)\(....\)/\1-\2-\3/')
            echo "$formatted"
            consultationDay=$formatted
            break
        fi
    done

    while true; do
        echo -e "Área da consulta (Digite o número da opção): "
        echo "1 - Fisioterapia"
        echo "2 - Dermatologia"
        echo "3 - Ginecologia"
        read area
        if [[ "$area" != "1" && "$area" != "2" && "$area" != "3" ]]; then
            echo "Opção inválida. Escolha uma das opções disponíveis."
        else
            case $area in
                1) area="Fisioterapia" ;;
                2) area="Dermatologia" ;;
                3) area="Ginecologia" ;;
            esac
            break
        fi
    done

    file="$PROJECT_URL/database/patients_consulta_marc.txt"
    id=$(wc -l < "$file")
    id=$((id + 1))

    if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area" >> "$file"; then
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
    while IFS=';' read -r id name gender birth phone consultationDay area; do
        echo "Id: $id"
        echo "Nome: $name"
        echo "Gênero: $gender"
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
    
    file="$PROJECT_URL/database/patients_consulta_marc.txt"
    
    found=false
    
    while IFS=';' read -r id name gender birth phone consultationDay area; do
        if [ "$id" == "$search_id" ]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Gênero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area consulta: $area"
            echo "-------------------"
            found=true
            
           subFunctionScheduleExam "$name" "$gender" "$birth" "$phone" "$consultationDay" "$area"
         # Criar um arquivo temporário
        temp_file=$(mktemp)

        grep -v "^$search_id;" "$file" > "$temp_file"
        
        if [ -f "$temp_file" ]; then
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
    	echo -e "Genero: "
    	read gender
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
    
            subFunctionScheduleExam "$name" "$gender" "$birth" "$phone" "$consultationDay" "$area"
    fi
    
    # Salvar os dados em um arquivo de texto e verificar o sucesso
    
    file="$PROJECT_URL/database/patients_exame_marc.txt"
    
    id=$(wc -l < "$file")
    
    id=$((id + 1))
    
    if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area" >> "$file"; then
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
    while IFS=';' read -r id name gender birth phone consultationDay area; do
        echo "Id: $id"
        echo "Nome: $name"
        echo "Genero: $gender"
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
    gender="$gender"
    birth="$birth"
    phone="$phone"
    consultationDay="$consultationDay"
    area="$area"
    
    file="$PROJECT_URL/database/patients_exame_marc.txt"
    
    id=$(wc -l < "$file")
    
    id=$((id + 1))
    
    if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area" >> "$file"; then
      
        echo ""
        echo "Exame marcado com sucesso!"
    else
        echo ""
        echo "Ups! Erro ao salvar. Verifique as permissões ou tente novamente."
    fi
    
    echo ""
    echo -e "1. Voltar"
    while true; do
    	read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
    	    ./patient.sh
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
		cd auth
		chmod +x login.sh
		./login.sh
		;;	
	*) 
		echo "Opcao nao disponivel, escolha um dos numeros apresentados!"
		echo ""
		;;	
esac	
