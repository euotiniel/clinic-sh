#!/bin/bash

source ../config.sh

# Sets

database_dir="$database_dir"

patients_consulta_db="$database_dir/patients_consulta_marc.txt"

patients_consulta_historic="$database_dir/historic/patients_consulta_historic.txt"

patients_exame_db="$database_dir/patients_exame_marc.txt"

patients_exame_historic="$database_dir/historic/patients_exame_historic.txt"

consultations_done="$database_dir/consultations_done.txt"

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
    echo -e "MARCAR EXAME"
    echo ""
    echo -e "Digite os dados do paciente:"
    echo ""
    echo -e "Id da consulta: "
    read search_id

    file="$database_dir/patients_consulta_marc.txt"

    found=false

    while IFS=';' read -r id name gender birth phone consultationDay area status; do
        if [ "$id" == "$search_id" ]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Gênero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area de consulta: $area"
            echo "Estado do paciente: $status"
            echo "-------------------"
            found=true

            subFunctionScheduleExam "$name" "$gender" "$birth" "$phone" "$consultationDay" "$area" "$status"

            # Histórico
            if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status" >>"$consultations_done"; then
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

function ver_pacientes {
	clear

	echo "Sucesso. "
	echo "1. Voltar"
	echo "2. Sair"

	read -p "Escolha uma opção: " caso

	if [ "$caso" == "1" ]; then
		./doctor.sh
	fi

	if [ "$caso" == "2" ]; then
		./main.sh
	fi
}

function historico_pacientes {
	clearx

	echo "Sucesso. "
	echo "1. Voltar"
	echo "2. Sair"

	read -p "Escolha uma opção: " caso

	if [ "$caso" == "1" ]; then
		./doctor.sh
	fi

	if [ "$caso" == "2" ]; then
		./main.sh
	fi
}

function subFunctionScheduleExam {
    local name="$1"
    local gender="$2"
    local birth="$3"
    local phone="$4"
    local consultationDay="$5"
    local area="$6"
    local status="$7"

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
4 - Realizar exames
5 - Verificar resultados de exames
6 - Historico 
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
	
	echo "Meus Pacientes"
	ver_pacientes
	echo ""
	;;
4)
	echo "Historico de Pacientes"
	historico_pacientes
	echo ""
	;;
5)
	echo "5. "
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
