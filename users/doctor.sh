#!/bin/bash

source ../config.sh

# Sets

database_dir="$PROJECT_URL/database"

patients_consulta_db="$database_dir/patients_consulta_marc.txt"

patients_consulta_historic="$database_dir/historic/patients_consulta_historic.txt"

patients_exame_db="$database_dir/patients_exame_marc.txt"

patients_exame_historic="$database_dir/historic/patients_exame_historic.txt"

consultations_done="$database_dir/consultations_done.txt"

exams_done="$database_dir/exames_done.txt"

doctor_consulta_historic="$database_dir/historic/doctor_consulta_historic.txt"

doctor_exame_historic="$database_dir/historic/doctor_exame_historic.txt"



function myQueries {
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
	while IFS=';' read -r id name gender birth phone consultationDay area status paid; do
		if [[ -n "${id// /}" ]]; then
			echo "Id: $id"
			echo "Nome: $name"
			echo "Gênero: $gender"
			echo "Data de Nascimento: $birth"
			echo "Telefone: $phone"
			echo "Dia da Consulta: $consultationDay"
			echo "Area de consulta: $area"
			echo "Estado do paciente: $status"
			echo "Pago: $paid"
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

function carryConsultations {
	clear
    echo ""
    echo -e "REALIZAR CONSULTAS"
    echo ""
    echo -e "Digite os dados do paciente:"
    echo ""
    
    while true; do
        echo -e "Id da consulta: "
        read search_id

        echo -e "Nota do paciente: "
        read nota
        
        file="$database_dir/patients_consulta_marc.txt"
        found=false

        while IFS=';' read -r id name gender birth phone consultationDay area status paid old_nota; do
            if [ "$id" == "$search_id" ]; then
                echo "Id: $id"
                echo "Nome: $name"
                echo "Gênero: $gender"
                echo "Data de Nascimento: $birth"
                echo "Telefone: $phone"
                echo "Dia da Consulta: $consultationDay"
                echo "Area de consulta: $area"
                echo "Estado do paciente: $status"
                echo "Pago: $paid"
                echo "Nota: $nota"
                echo "-------------------"
                found=true

                subFunctionScheduleExam "$name" "$gender" "$birth" "$phone" "$consultationDay" "$area" "$status" "$nota"

                if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$paid;$nota" >>"$consultations_done"; then
                    echo ""
                else
                    echo ""
                fi

                sed -i "${search_id}s/.*/ /" "$database_dir/patients_consulta_marc.txt"
                break
            fi
        done <"$file"

       if [ "$found" = true ]; then
            echo ""
            while true; do
                read -p "Digite 1 para voltar: " caso
                if [ "$caso" == "1" ]; then
                    ./doctor.sh
                    exit
                fi
            done
        else

			echo ""
			echo "----------------------------"
            echo -e "ID do usuário não encontrado."
            while true; do
				echo "-------------------"
                echo "Escolha uma opção:"
                echo "1. Tentar novamente"
                echo "2. Voltar"
                read caso
				clear

                if [ "$caso" == "1" ]; then
                    break
                elif [ "$caso" == "2" ]; then
                    ./doctor.sh
                    exit
                else
                    echo "Opção inválida, tente novamente."
                fi
            done
			clear
        fi
    done
}

function checkQueryResults {
	clear
    echo ""
    echo -e "RESULTADOS DE CONSULTA"
    echo ""
    echo -e "Digite os dados do paciente:"
    echo ""
	echo -e "Id da consulta: "
    read search_id

	  file="$database_dir/consultations_done.txt"
      found=false
	if [ -s "$file" ]; then
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
                echo "Pago: $paid"
                echo "Nota: $nota"
                echo "-------------------"
                found=true
            fi
        done <"$file"

		 if ! $found; then
            echo -e "Nenhuma marcação de exame encontrada para o ID informado."
        fi
    else
        echo -e "Nenhuma marcação de exame encontrada no arquivo."
    fi

    echo ""
    echo -e "1. Voltar"

    while true; do
        read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
            ./doctor.sh
            break
        else
            echo "Opção inválida, tente novamente."
        fi
    done
    

}

function myExams {
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
    while IFS=';' read -r id name gender birth phone consultationDay area status nota; do
        if [[ -n "${id// /}" ]]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Genero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area de consulta: $area"
            echo "Estado do paciente: $status"
			#echo "$nota"
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

function performExams {
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

function checkExamResults {

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

    # Debug: Verifique se a variável 'nota' está sendo recebida corretamente
    #echo "Nota recebida na subfunção: $nota"

    file="$database_dir/patients_exame_marc.txt"

    id=$(wc -l <"$file")

    id=$((id + 1))

    if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$nota" >>"$file"; then
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
	myQueries
	;;
2)
	carryConsultations
	;;
3)	
	checkQueryResults
	;;
4)
	myExams 
	;;
5) performExams
	;;

6) checkExamResults
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
