#!/bin/bash

database_dir="/home/fabiana/Documents/SO I/projecto_clinica/database"

patients_file="$database_dir/patients.txt"
if [ ! -f "$patients_file" ]; then
    touch "$patients_file"
fi

# Verifica se doctor.txt existe, se não existir, cria
# doctor_file="$database_dir/doctors.txt"
# if [ ! -f "$doctor_file" ]; then
#    touch "$doctor_file"
# fi

name=$(whoami)

clear
echo "BEM-VINDO/A, $name"
echo "-----------------------"
echo " 
1. Paciente
2. Medico
3. Sair
"
echo "Escolha uma das opcoes: "

echo ""

read option

echo ""


case $option in 
	
	1) 
		cd users
		chmod +x patient.sh
		./patient.sh
		;;
	2) 
		cd users
		chmod +x doctor.sh
		./doctor.sh
		;;
	3) 
		echo "Tirando o pe..."
		exit
		;;	
	*) 
		echo "Opcao nao disponivel, escolha um dos numeros apresentados!"
		echo ""
		;;	
esac

