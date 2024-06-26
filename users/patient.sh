#!/bin/bash

source ../config.sh

# Sets

database_dir="$PROJECT_URL/database"

patients_consulta_db="$database_dir/patients_consulta_marc.txt"

patients_consulta_historic="$database_dir/historic/patients_consulta_historic.txt"

patients_exame_db="$database_dir/patients_exame_marc.txt"

patients_exame_historic="$database_dir/historic/patients_exame_historic.txt"

consultations_done="$database_dir/consultations_done.txt"


exames_done="$database_dir/exames_done.txt"

doctor_consulta_historic="$database_dir/historic/doctor_consulta_historic.txt"

doctor_exame_historic="$database_dir/historic/doctor_exame_historic_doctor.txt"

if [ -d "$database_dir/historic" ]; then
    echo ""
else
    mkdir "$database_dir/historic"
fi

if [ ! -f "$patients_consulta_db" ]; then
    touch "$patients_consulta_db"
fi

if [ ! -f "$patients_exame_db" ]; then
    touch "$patients_exame_db"
fi

if [ ! -f "$patients_consulta_historic" ]; then
    touch "$patients_consulta_historic"
fi

if [ ! -f "$patients_exame_historic" ]; then
    touch "$patients_exame_historic"
fi

if [ ! -f "$doctor_consulta_historic" ]; then
    touch "$doctor_consulta_historic"
fi

if [ ! -f "$doctor_exame_historic" ]; then
    touch "$doctor_exame_historic"
fi

if [ ! -f "$exams_done" ]; then
    touch "$exams_done"
fi

if [ ! -f "$consultations_done" ]; then
    touch "$consultations_done"
fi

if [ ! -f "$exames_done" ]; then
    touch "$exames_done"
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

    while true; do
        echo -e "Estado do paciente: "
        echo "1 - Grave"
        echo "2 - Não grave"
        read status
        if [[ "$status" != "1" && "$status" != "2" ]]; then
            echo "Opção inválida. Escolha uma das opções disponíveis."
        else
            case $status in
            1) status="Grave" ;;
            2) status="Não grave" ;;
            esac
            break
        fi
    done

    if [ "$status" == "Grave" ]; then
        paid=false
    else
        payMarking
        paid=true
    fi

    file="$database_dir/patients_consulta_marc.txt"
    id=$(wc -l <"$file")
    id=$((id + 1))

    if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$paid" >>"$file"; then
        echo ""
        echo "MARCACAO FEITA COM SUCESSO!"
    else
        echo ""
        echo "Erro ao salvar a marcação. Verifique as permissões ou tente novamente."
    fi

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

    file="$database_dir/patients_consulta_marc.txt"

    if [ ! -f "$file" ] || [ ! -s "$file" ]; then
        echo -e "Lista de marcacoes vazia."
        echo ""

        while true; do
            read -p "Digite 1 para voltar: " caso

            if [ "$caso" == "1" ]; then
                ./patient.sh
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


    file="$database_dir/consultations_done.txt"

    found=false

    while IFS=';' read -r id name gender birth phone consultationDay area status paid; do
        if [ "$id" == "$search_id" ]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Gênero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Área de consulta: $area"
            echo "Estado do paciente: $status"
            echo "Pago: $paid"
            echo "-------------------"
            found=true

            if [ "$status" == "Grave" ]; then
                paid=false
            else
                payExams
                paid=true
            fi

            subFunctionScheduleExam "$name" "$gender" "$birth" "$phone" "$consultationDay" "$area" "$status" "$paid"

            # Histórico
            if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$paid" >>"$patients_consulta_historic"; then
                echo ""
            else
                echo ""
            fi

            break 
        fi
    done <"$file"

    if ! $found; then
        echo "Nenhum registro encontrado."

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
                echo "Telefone inválido. Deve conter entre 9 e 13 dígitos numéricos."
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

        while true; do
            echo -e "Estado do paciente: "
            echo "1 - Grave"
            echo "2 - Não grave"
            read status
            if [[ "$status" != "1" && "$status" != "2" ]]; then
                echo "Opção inválida. Escolha uma das opções disponíveis."
            else
                case $status in
                1) status="Grave" ;;
                2) status="Não grave" ;;
                esac
                break
            fi
        done

        if [ "$status" == "Grave" ]; then
            paid=false
        else
            payExams
            paid=true
        fi

        subFunctionScheduleExam "$name" "$gender" "$birth" "$phone" "$consultationDay" "$area" "$status" "$paid"

        # Salvar os dados do exame no arquivo
        file="$database_dir/patients_exame_marc.txt"

        id=$(wc -l <"$file")
        id=$((id + 1))

        if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$paid" >>"$file"; then
            echo ""
        else
            echo ""
            echo "Erro ao salvar a marcação de exame. Verifique as permissões ou tente novamente."
        fi
    fi

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
    file="$database_dir/patients_exame_marc.txt"

    if [ ! -s "$file" ]; then
        echo -e "Nenhuma marcao de exame."
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
    while IFS=';' read -r id name gender birth phone consultationDay area status paid; do
        if [[ -n "${id// /}" ]]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Genero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area de consulta: $area"
            echo "Estado do paciente: $status"
            echo "Pago: " $paid
            echo "-------------------"
        fi
    done <"$file"

    echo ""

    while true; do
        read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
            ./patient.sh
            break
        fi
    done
}

function noPaymentMarking {
    clear
    echo ""
    echo -e "Consultas com Pagamento em Atraso"
    echo ""

    file="$consultations_done"

    # if [ ! -s "$file" ]; then
    #     echo -e "Nenhuma marcação encontrada."
    #     echo ""
    #     echo -e "1. Voltar"
    #     echo ""

    #     while true; do
    #         read -p "Digite 1 para voltar: " caso

    #         if [ "$caso" == "1" ]; then
    #             ./patient.sh
    #             return
    #         fi
    #     done
    # fi

    found=false

    while IFS=';' read -r id name gender birth phone consultationDay area status paid; do
        if [[ "$paid" == "false" ]]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Genero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area de consulta: $area"
            echo "Estado do paciente: $status"
            echo "Pago: $paid"
            echo "-------------------"
            found=true
        fi
    done < "$file"

    if ! $found; then
        echo "Nenhum pagamento em atraso encontrado."
    fi

    echo ""


    while true; do
        read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
            ./patient.sh
            return
        fi
    done
}

function noPaymentExames {
    clear
    echo ""
    echo -e "Exames com Pagamento em Atraso"
    echo ""

    file="$exames_done"

    # if [ ! -s "$file" ]; then
    #     echo -e "Nenhuma marcação encontrada."
    #     echo ""
    #     echo -e "1. Voltar"
    #     echo ""

    #     while true; do
    #         read -p "Digite 1 para voltar: " caso

    #         if [ "$caso" == "1" ]; then
    #             ./patient.sh
    #             return
    #         fi
    #     done
    # fi
    
    found=false

    while IFS=';' read -r id name gender birth phone consultationDay area status paid; do
        if [[ "$paid" == "false" ]]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Genero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area de consulta: $area"
            echo "Estado do paciente: $status"
            echo "Pago: $paid"
            echo "-------------------"
            found=true
        fi
    done < "$file"

    if ! $found; then
        echo "Nenhum pagamento em atraso encontrado."
    fi

    echo ""


    while true; do
        read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
            ./patient.sh
            return
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
    local paid="$8"

    file="$database_dir/patients_exame_marc.txt"

    id=$(wc -l <"$file")

    id=$((id + 1))

    if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$paid" >>"$file"; then
        echo ""
        echo "Exame marcado com sucesso!"
    else
        echo ""
        echo "Ups! Erro ao salvar. Verifique as permissões ou tente novamente."
    fi
}

function payMarking {
    echo ""
    echo "PAGAMENTO DA CONSULTA"
    echo "----------------------"
    echo ""
    echo "Seleciona a forma de pagamento:"
    echo "
1 - Dinheiro
2 - Transferência
    "

    while true; do
        read -p "Seleciona uma das opcoes: " option

        case $option in
        1)
            echo ""
            echo "Pagamento em Dinheiro selecionado."
            echo ""
            echo "Valor a pagar: 10.000 kzs"
            echo ""
            echo -e "1. Confirmar"
            echo ""

            while true; do
                read confirm

                if [ "$confirm" == "1" ]; then
                    break
                fi
            done
            break
            ;;
        2)
            echo ""
            echo "Pagamento com transferência selecionado"
            echo ""
            echo "Valor a pagar: 10.000 kzs"
            echo ""
            echo "Referência: AO06.0040.0000.3301.4458.1018.5"
            echo ""
            echo -e "1. Confirmar recepção do comprovativo"
            echo ""

            while true; do
                read confirm

                if [ "$confirm" == "1" ]; then
                    break
                fi
            done
            break
            ;;
        *)
            echo ""
            echo "Opção inválida. Por favor, selecione 1 ou 2."
            echo ""
            ;;
        esac

    done
}


function payExams {
        echo ""
    echo "PAGAMENTO DO EXAME"
    echo "----------------------"
    echo ""
    echo "Seleciona a forma de pagamento:"
    echo "
1 - Dinheiro
2 - Transferência
    "

    while true; do
        read -p "Seleciona uma das opcoes: " option

        case $option in
        1)
            echo ""
            echo "Pagamento em Dinheiro selecionado."
            echo ""
            echo "Valor a pagar: 25.000 kzs"
            echo ""
            echo -e "1. Confirmar"
            echo ""

            while true; do
                read confirm

                if [ "$confirm" == "1" ]; then
                    break
                fi
            done
            break
            ;;
        2)
            echo ""
            echo "Pagamento com transferência selecionado"
            echo ""
            echo "Valor a pagar: 25.000 kzs"
            echo ""
            echo "Referência: AO06.0040.0000.3301.4458.1018.5"
            echo ""
            echo -e "1. Confirmar recepção do comprovativo"
            echo ""

            while true; do
                read confirm

                if [ "$confirm" == "1" ]; then
                    break
                fi
            done
            break
            ;;
        *)
            echo ""
            echo "Opção inválida. Por favor, selecione 1 ou 2."
            echo ""
            ;;
        esac

    done
}

# Main

clear
echo "MENU PACIENTE"
echo "--------------"

echo " 
1 - Fazer marcacao
2 - Consultar marcacoes
3 - Marcar exames
4 - Consultar exames
5 - Pagamentos pendentes - Consultas
6 - Pagamentos pendentes - Exames
7 - Sair
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
    noPaymentMarking
    ;;
6)
    noPaymentExames
    ;;
7)
    clear
    cd ..
    cd auth
    chmod a+x login.sh
    ./login.sh
    ;;
*)
    echo "Opcao nao disponivel, escolha um dos numeros apresentados!"
    echo ""
    chmod a+x patient.sh
    ./patient.sh
    ;;
esac
