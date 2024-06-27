#!/bin/bash

source ../config.sh

database_dir="$PROJECT_URL/database"

# Paciente

patients_consulta_db="$database_dir/patients_consulta_marc.txt"

patients_exame_db="$database_dir/patients_exame_marc.txt"

patients_consulta_historic="$database_dir/historic/patients_consulta_historic.txt"

patients_exame_historic="$database_dir/historic/patients_exame_historic.txt"

# Doctor

consultations_done="$database_dir/consultations_done.txt"

exams_done="$database_dir/exams_done.txt"

doctor_consulta_historic="$database_dir/historic/doctor_consulta_historic.txt"

doctor_exame_historic="$database_dir/historic/doctor_exame_historic.txt"



function myqueries {
	clear
	echo ""
	echo -e "MINHAS CONSULTAS"
	echo ""

	file="$database_dir/patients_consulta_marc.txt"

	if [ ! -f "$file" ] || [ ! -s "$file" ]; then
		echo -e "Lista de marcacoes vazia."
		echo ""
		echo -e "1. Voltar"
		echo ""

		while true; do
			read -p "Digite 1 para voltar: " caso

			if [ "$caso" == "1" ]; then
				./doctor.sh
				break
			fi
		done
	fi

	echo -e "Lista de Marcacoes:"
	echo ""
	while IFS=';' read -r id name gender birth phone consultationDay area status; do
		if [[ -n "${id// /}" ]]; then
			echo "Id: $id"
			echo "Nome: $name"
			echo "Gênero: $gender"
			echo "Data de Nascimento: $birth"
			echo "Telefone: $phone"
			echo "Dia da Consulta: $consultationDay"
			echo "Area de consulta: $area"
			echo "Estado do paciente: $status"
			echo "-------------------"
		fi
	done <"$file"

	echo ""
	echo -e "1. Voltar"
	echo ""

	while true; do
		read -p "Digite 1 para voltar: " caso

		if [ "$caso" == "1" ]; then
			./doctor.sh
			break
		fi
	done
}

function carryconsultations {
	clear
    echo ""
    echo -e "REALIZAR CONSULTAS"
    echo ""
    echo -e "Digite os dados do paciente:"
    echo ""
    echo -e "Id da consulta: "
    read search_id

    file="$database_dir/patients_consulta_marc.txt"

    found=false

	echo -e "Nota do paciente"
	read nota
	
	echo""
    while IFS=';' read -r id name gender birth phone consultationDay area status paid nota; do
        if [ "$id" == "$search_id" ]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Gênero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area de consulta: $area"
            echo "Estado do paciente: $status"
			echo "Nota: $nota"
            echo "-------------------"
            found=true

            subFunctionScheduleExam "$name" "$gender" "$birth" "$phone" "$consultationDay" "$area" "$status" "$nota"

            if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$nota" >>"$consultations_done"; then
                echo ""
            else
                echo ""
            fi

            # Remover linha do arquivo
            sed -i "${search_id}s/.*/ /" "$database_dir/patients_consulta_marc.txt"

            break  # Sair do loop após encontrar o registro
        fi
	done <"$file"

	echo ""


    while true; do
        read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
            ./doctor.sh
            break
        fi
    done
}

function checkqueryresults {
	clear
	echo ""
	echo -e "RESULTADOS"
	echo ""

	file="$PROJECT_URL/database/consultations_done.txt"

	if [ ! -f "$file" ] || [ ! -s "$file" ]; then
		echo -e "Lista de resultado vazia."
		echo ""
		echo -e "1. Voltar"
		echo ""

		while true; do
			read -p "Digite 1 para voltar: " caso

			if [ "$caso" == "1" ]; then
				./doctor.sh
				break
			fi
		done
	fi

	echo -e "Lista de Resultados:"
	echo ""
	while IFS=';' read -r id name gender birth phone consultationDay area status paid nota; do
		if [[ -n "${id// /}" ]]; then
			echo "Id: $id"
			echo "Nome: $name"
			echo "Gênero: $gender"
			echo "Data de Nascimento: $birth"
			echo "Telefone: $phone"
			echo "Dia da Consulta: $consultationDay"
			echo "Area de consulta: $area"
			echo "Estado do paciente: $status"
			echo "Nota: $nota"
			echo "-------------------"
		fi
	done <"$file"

	echo ""
	echo -e "1. Voltar"
	echo ""

	while true; do
		read -p "Digite 1 para voltar: " caso

		if [ "$caso" == "1" ]; then
			./doctor.sh
			break
		fi
	done
}

function myexams {
	clear
    echo ""
    echo -e "Exames Marcados"
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
                ./doctor.sh
                break
            fi
        done
    fi

    # Exibir as marcações existentes
    echo -e "Marcacoes para exames:"
    echo ""
    while IFS=';' read -r id name gender birth phone consultationDay area status; do
        if [[ -n "${id// /}" ]]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Genero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area de consulta: $area"
            echo "Estado do paciente: $status"
            echo "-------------------"
        fi
    done <"$file"

    echo ""
    echo -e "1. Voltar"
    echo ""

    while true; do
        read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
            ./doctor.sh
            break
        fi
    done
}

function performexams {
	clear
    echo ""
    echo -e "REALIZAR EXAMES"
    echo ""
    echo -e "Digite os dados do paciente:"
    echo ""
    echo -e "Id da consulta: "
    read search_id

    file="$PROJECT_URL/database/patients_exame_marc.txt"

    found=false
    while IFS=';' read -r id name gender birth phone consultationDay area status paid nota; do
        if [ "$id" == "$search_id" ]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Gênero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area de consulta: $area"
            echo "Estado do paciente: $status"
			echo "Nota: $nota"
            echo "-------------------"
            found=true

            subFunctionScheduleExam "$name" "$gender" "$birth" "$phone" "$consultationDay" "$area" "$status" "$nota"

            # Histórico
            if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$nota" >>"$exams_done"; then
                echo ""
            else
                echo ""
            fi

            # Remover linha do arquivo
            sed -i "${search_id}s/.*/ /" "$PROJECT_URL/database/patients_consulta_marc.txt"

            break  # Sair do loop após encontrar o registro
        fi
	done <"$file"

	echo ""
    echo -e "1. Voltar"
    echo ""

    while true; do
        read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
            ./doctor.sh
            break
        fi
    done

}

function checkexamresults {

	clear
	echo ""
	echo -e "RESULTADOS"
	echo ""

	file="$PROJECT_URL/database/exams_done.txt"

	if [ ! -f "$file" ] || [ ! -s "$file" ]; then
		echo -e "Lista de resultado vazia."
		echo ""
		echo -e "1. Voltar"
		echo ""

		while true; do
			read -p "Digite 1 para voltar: " caso

			if [ "$caso" == "1" ]; then
				./doctor.sh
				break
			fi
		done
	fi

	echo -e "Lista de Resultados:"
	echo ""
	while IFS=';' read -r id name gender birth phone consultationDay area status paid nota; do
		if [[ -n "${id// /}" ]]; then
			echo "Id: $id"
			echo "Nome: $name"
			echo "Gênero: $gender"
			echo "Data de Nascimento: $birth"
			echo "Telefone: $phone"
			echo "Dia da Consulta: $consultationDay"
			echo "Area de consulta: $area"
			echo "Estado do paciente: $status"
			echo "Nota: $nota"
			echo "-------------------"
		fi
	done <"$file"

	echo ""
	echo -e "1. Voltar"
	echo ""

	while true; do
		read -p "Digite 1 para voltar: " caso

		if [ "$caso" == "1" ]; then
			./doctor.sh
			break
		fi
	done
}

function subFunctionScheduleExam {
    local name="$1"
    local gender="$2"
    local birth="$3"
    local phone="$4"
    local consultationDay="$5"
    local area="$6"
    local status="$7"
	local nota="$8"


    file="$database_dir/patients_exame_marc.txt"

    id=$(wc -l <"$file")

    id=$((id + 1))

	

    if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status" >>"$file"; then
        echo ""
        echo "Consulta realizada com sucesso!"
    else
        echo ""
        echo "Ups! Erro ao salvar. Verifique as permissões ou tente novamente."
    fi

}

name=$(whoami)

clear
echo "MENU DOCTOR"
echo "------------"
usuario=$(whoami)
nome=$(finger $usuario | awk -F: '/Name/ {print $3}' | tr -d ' ')
echo "Bem vindo/a $nome"
echo " 
1 - Minhas Consultas
2 - Realizar consultas
3 - Verificar resultados de Consultas
4 - Meus exames
5 - Realizar exames
6 - Verificar resultados de exames
7 - Sair
"
echo ""

echo "Escolha uma das opcoes: "

echo ""

read option

echo ""

case $option in

1)
	myqueries
	;;
2)
	carryconsultations
	;;
3)	
	checkqueryresults
	;;
4)
	myexams 
	;;
5) performexams
	;;

6) checkexamresults
	;;

7)
	echo "5."
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
