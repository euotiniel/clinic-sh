#!/bin/bash

# Functions

function makeMarking {
	clear
    	echo ""
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
    
    file="/home/fabiana/Documents/SO I/projecto_clinica/database/patients.txt"
    
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
    echo "1. Voltar"
    echo "2. Sair"
    
    read -p "Escolha uma opção: " caso

    if [ "$caso" == "1" ]; then
       	./patient.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 ../main.sh
    fi
}

function consultMarking {
    clear
    echo ""
    echo -e "CONSULTAR MARCACOES"
    echo ""

    # Verifica se o arquivo existe
    
    file="/home/fabiana/Documents/SO I/projecto_clinica/database/patients.txt"
    
    if [ ! -f "$file" ]; then
        echo "Nenhuma marcação encontrada."
        return
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
    echo "1. Voltar"
    echo "2. Sair"
    
    read -p "Escolha uma opção: " caso

    if [ "$caso" == "1" ]; then
       	./patient.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 ../main.sh
    fi
}


function scheduleExams {
	clear
    echo ""
    echo -e "MARCAR EXAME"
    echo ""
    echo -e "Digite os dados do paciente:"
    echo ""
    echo -e "Id da consulta: "
    read idCons
    
    
    echo -e "Data de nascimento (ddmmaaaa): "
    read birth
    echo -e "Telefone: "
    read phone
    echo -e "Dia da consulta (ddmmaaaa): "
    read consultationDay

    # Salvar os dados em um arquivo de texto e verificar o sucesso
    
    file="/home/fabiana/Documents/SO I/projecto_clinica/database/patients.txt"
    
    if echo "$name;$birth;$phone;$consultationDay" >> "$file"; then
        echo ""
        echo "Marcação feita com sucesso!"
    else
        echo ""
        echo "Erro ao salvar a marcação. Verifique as permissões ou tente novamente."
    fi
    
    echo ""
    echo "1. Voltar"
    echo "2. Sair"
    
    read -p "Escolha uma opção: " caso

    if [ "$caso" == "1" ]; then
       	./patient.sh
    fi
    			
    if [ "$caso" == "2" ]; then
    	 ../main.sh
    fi
}

function checkExams {
	clear
	echo ""
	echo "Consultar exames"
}


name=$(whoami)

clear
echo "MENU PACIENTE"
echo "--------------"
echo ""
echo " 
1. Fazer marcacao
2. Consultar marcacoes
3. Marcar exames
4. Consultar exames
5. Sair
"
echo ""

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
		makeAppointment
		;;
	4) 
		scheduleExams
		;;
	5) 
		echo "Voltando ao meno principal..."
		cd ..
		chmod +x main.sh
		./main.sh
		;;	
	*) 
		echo "Opcao nao disponivel, escolha um dos numeros apresentados!"
		echo ""
		;;	
esac
		
