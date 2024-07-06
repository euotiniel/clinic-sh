#!/bin/bash

source ../config.sh

# LOGS

# Definindo o diretório de logs
logs="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)/logs"

# Função para registrar informações no log
log_info() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1" >>"$logs/system.log"
}

# Função para registrar erros no log
log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $1" >>"$logs/error.log"
}

database_dir="$PROJECT_URL/database"

# Paciente

patients_consulta_db="$database_dir/patients_consulta_marc.txt"

patients_exame_db="$database_dir/patients_exame_marc.txt"

patients_consulta_historic="$database_dir/historic/patients_consulta_historic.txt"

patients_exame_historic="$database_dir/historic/patients_exame_historic.txt"

mortality="$database_dir/mortality.txt"

# Doctor

consultations_done="$database_dir/consultations_done.txt"

exams_done="$database_dir/exams_done.txt"

doctor_consulta_historic="$database_dir/historic/doctor_consulta_historic.txt"

doctor_exame_historic="$database_dir/historic/doctor_exame_historic.txt"

# Sets

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


if [ ! -f "$mortality" ]; then
    touch "$mortality"
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
        if [[ ! "$birth" =~ ^([0-9]{2})([0-9]{2})([0-9]{4})$ ]]; then
            echo "Formato inválido. Use o formato ddmmaaaa (8 dígitos)."
        else
            day="${birth:0:2}"
            month="${birth:2:2}"
            year="${birth:4:4}"

            # setar os dados como int

            ((day = 10#$day))
            ((month = 10#$month))
            ((year = 10#$year))

            if ((day < 1 || day > 31)); then
                echo "Dia inválido. Deve estar entre 01 e 31."
            elif ((month < 1 || month > 12)); then
                echo "Mês inválido. Deve estar entre 01 e 12."
            elif ((year < 1 || year > 2024)); then
                echo "Ano inválido. Deve estar entre 0001 e 2024."
            else
                birth_formatted="${day}-${month}-${year}"
                echo "$birth_formatted"
                birth=$birth_formatted
                break
            fi
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
        read -p "Data da consulta (ddmmaaaa): " consultationDay
        if [[ ! "$consultationDay" =~ ^([0-9]{2})([0-9]{2})([0-9]{4})$ ]]; then
            echo "Formato inválido. Use o formato ddmmaaaa (8 dígitos)."
        else
            day="${consultationDay:0:2}"
            month="${consultationDay:2:2}"
            year="${consultationDay:4:4}"

            # Convertendo para números inteiros
            ((day = 10#$day))
            ((month = 10#$month))
            ((year = 10#$year))

            current_month=$(date +%m)
            current_year=$(date +%Y)

            if ((day < 1 || day > 31)); then
                echo "Dia inválido. Deve estar entre 01 e 31."
            elif ((month < 1 || month > 12)); then
                echo "Mês inválido. Deve estar entre 01 e 12."
            elif ((year < 1 || year > 2024)); then
                echo "Ano inválido. Deve estar entre 0001 e 2024."
            elif ((year < current_year)); then
                echo "Ano da consulta não pode ser anterior ao ano atual (${current_year})."
            elif ((year == current_year && month < current_month)); then
                echo "Mês da consulta não pode ser anterior ao mês atual (${current_month})."
            else
                formatted="${day}-${month}-${year}"
                echo "$formatted"
                consultationDay=$formatted
                break
            fi
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

    nota=""

    file="$patients_consulta_db"
    id=$(wc -l <"$file")
    id=$((id + 1))

    if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$paid;$nota" >>"$file"; then
        echo ""
        echo "MARCACAO FEITA COM SUCESSO!"
        log_info "O usuário $usuario fez uma marcacao de consulta para o paciente $name"
    else
        echo ""
        echo "Erro ao salvar a marcação. Verifique as permissões ou tente novamente."
        log_error "Erro ao fazer marcacao de consulta, usuario $usuario"
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
    echo -e "CONSULTAR MARCACOES DE CONSULTA"
    echo ""

    file="$patients_consulta_db"

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
            echo "Pago: $paid"
            echo "$nota"
            echo "-------------------"
        fi
    done <"$file"

    log_info "O usuário $usuario acessou a lista de marcacoes para consultas"

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

    file="$consultations_done"

    found=false

    while IFS=';' read -r id name gender birth phone consultationDay area status paid nota; do
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
            echo "$nota"
            echo ""
            echo "-------------------"
            found=true

            
            # break
        fi
    done <"$file"

    if [ "$status" == "Grave" ]; then
                paid=false
            else
                payExams
                paid=true
            fi

            # break

            subFunctionScheduleExam "$name" "$gender" "$birth" "$phone" "$consultationDay" "$area" "$status" "$paid" "$nota"

            # Histórico
            if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$paid;$nota" >>"$patients_consulta_historic"; then
                log_info "O usuário $usuario salvou a marcacao de exame do paciente $name"
            else
                log_error "Erro ao fazer marcacao de exame, usuario $usuario"
            fi


    log_info "O usuário $usuario fez uma marcacao de exame para o paciente $name"

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
            if [[ ! "$birth" =~ ^([0-9]{2})([0-9]{2})([0-9]{4})$ ]]; then
                echo "Formato inválido. Use o formato ddmmaaaa (8 dígitos)."
            else
                day="${birth:0:2}"
                month="${birth:2:2}"
                year="${birth:4:4}"

                # setar os dados como int

                ((day = 10#$day))
                ((month = 10#$month))
                ((year = 10#$year))

                if ((day < 1 || day > 31)); then
                    echo "Dia inválido. Deve estar entre 01 e 31."
                elif ((month < 1 || month > 12)); then
                    echo "Mês inválido. Deve estar entre 01 e 12."
                elif ((year < 1 || year > 2024)); then
                    echo "Ano inválido. Deve estar entre 0001 e 2024."
                else
                    birth_formatted="${day}-${month}-${year}"
                    echo "$birth_formatted"
                    birth=$birth_formatted
                    break
                fi
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
            read -p "Data da consulta (ddmmaaaa): " consultationDay
            if [[ ! "$consultationDay" =~ ^([0-9]{2})([0-9]{2})([0-9]{4})$ ]]; then
                echo "Formato inválido. Use o formato ddmmaaaa (8 dígitos)."
            else
                day="${consultationDay:0:2}"
                month="${consultationDay:2:2}"
                year="${consultationDay:4:4}"

                # Convertendo para números inteiros
                ((day = 10#$day))
                ((month = 10#$month))
                ((year = 10#$year))

                current_month=$(date +%m)
                current_year=$(date +%Y)

                if ((day < 1 || day > 31)); then
                    echo "Dia inválido. Deve estar entre 01 e 31."
                elif ((month < 1 || month > 12)); then
                    echo "Mês inválido. Deve estar entre 01 e 12."
                elif ((year < 1 || year > 2024)); then
                    echo "Ano inválido. Deve estar entre 0001 e 2024."
                elif ((year < current_year)); then
                    echo "Ano da consulta não pode ser anterior ao ano atual (${current_year})."
                elif ((year == current_year && month < current_month)); then
                    echo "Mês da consulta não pode ser anterior ao mês atual (${current_month})."
                else
                    formatted="${day}-${month}-${year}"
                    echo "$formatted"
                    consultationDay=$formatted
                    break
                fi
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

        nota=""

        subFunctionScheduleExam "$name" "$gender" "$birth" "$phone" "$consultationDay" "$area" "$status" "$paid" "$nota"

        # Salvar os dados do exame no arquivo
        file="$patients_exame_db"

        id=$(wc -l <"$file")
        id=$((id + 1))

        if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$paid;$nota" >>"$file"; then
            echo ""
            log_info "O usuário $usuario fez uma marcacao de exame para o paciente $name"
        else
            echo ""
            echo "Erro ao salvar a marcação de exame. Verifique as permissões ou tente novamente."
            log_error "Erro ao fazer marcacao de exame, usuario $usuario"
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
    file="$patients_exame_db"

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
    while IFS=';' read -r id name gender birth phone consultationDay area status paid nota; do
        if [[ -n "${id// /}" ]]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Genero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area de consulta: $area"
            echo "Estado do paciente: $status"
            echo "Pago: $paid"
            echo "Nota: $nota"
            echo ""
            echo "-------------------"
        fi
    done <"$file"

    echo ""
    log_info "O usuário $usuario acessou a lista de marcacoes"

    while true; do
        read -p "Digite 1 para voltar: " caso

        if [ "$caso" == "1" ]; then
            ./patient.sh
            break
        fi
    done
}

function checkMortality {
    clear

    # Verifica se o arquivo existe
    file="$mortality"

    if [ ! -s "$file" ]; then
        echo -e "Nenhum paciente morto."
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
    echo -e "PACIENTES MORTPOS:"
    echo ""
    while IFS=';' read -r id name gender birth phone consultationDay area status paid nota; do
        if [[ -n "${id// /}" ]]; then
            echo "Id: $id"
            echo "Nome: $name"
            echo "Genero: $gender"
            echo "Data de Nascimento: $birth"
            echo "Telefone: $phone"
            echo "Dia da Consulta: $consultationDay"
            echo "Area de consulta: $area"
            echo "Estado do paciente: $status"
            echo "Pago: $paid"
            echo "Nota: $nota"
            echo "-------------------"
        fi
    done <"$file"

    echo ""
    log_info "O usuário $usuario acessou a lista dos pacientes mortos"

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
    echo -e "CONSULTAS COM PAGAMENTOS EM ATRASO"
    echo ""

    file="$consultations_done"

    if [ ! -s "$file" ]; then
        echo -e "Nenhuma marcação encontrada."
        echo ""
        echo -e "1. Voltar"
        echo ""

        while true; do
            read -p "Digite 1 para voltar: " caso

            if [ "$caso" == "1" ]; then
                ./patient.sh
                return
            fi
        done
    fi

    found=false

    while IFS=';' read -r id name gender birth phone consultationDay area status paid nota; do
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
            echo "Nota: $nota"
            echo "-------------------"
            found=true
        fi
    done <"$file"

    if ! $found; then
        echo "Nenhum pagamento em atraso encontrado."
    fi

    echo ""
    log_info "O usuário $usuario acessou a lista de consultas nao pagas"

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
    echo -e "EXAMES COM PAGAMENTO EM ATRASO"
    echo ""

    file="$exames_done"

    if [ ! -s "$file" ]; then
        echo -e "Nenhuma marcação encontrada."
        echo ""
        echo -e "1. Voltar"
        echo ""

        while true; do
            read -p "Digite 1 para voltar: " caso

            if [ "$caso" == "1" ]; then
                ./patient.sh
                return
            fi
        done
    fi

    found=false

    while IFS=';' read -r id name gender birth phone consultationDay area status paid nota; do
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
            echo "Nota: $nota"
            echo "-------------------"
            found=true
        fi
    done <"$file"

    if ! $found; then
        echo "Nenhum pagamento em atraso encontrado."
    fi

    echo ""
    log_info "O usuário $usuario acessou a lista de examos nao pagos"

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
    local nota="$9"

    file="$patients_exame_db"

    id=$(wc -l <"$file")

    id=$((id + 1))

    nota=""

    if echo "$id;$name;$gender;$birth;$phone;$consultationDay;$area;$status;$paid;$nota" >>"$file"; then
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
            choiseecho ""

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
        read -p "Seleciona uma das opcoes: " choise

        case $choise in
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
            echo "Opção inválida. Por favor, selecione 1 ou 2. rrrrrrrrrrrrrrrrrrrrrrrrrrrr"
            ;;
        esac

    done
}

# Main

name=$(whoami)

clear
echo "MENU PACIENTE"
echo "--------------
"

usuario=$(whoami)
nome=$(finger $usuario | awk -F: '/Name/ {print $3}' | tr -d ' ')
echo "Bem vindo/a $nome"

echo " 
1 - Fazer marcacao
2 - Consultar marcacoes
3 - Marcar exames
4 - Consultar exames
5 - Pagamentos pendentes - Consultas
6 - Pagamentos pendentes - Exames
7 - Listar pacientes mortos
8 - Sair
"

echo "Escolha uma das opcoes: "

echo ""

log_info "O usuário $usuario acessou o menu do paciente"

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
    checkMortality
    ;;
8)
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
