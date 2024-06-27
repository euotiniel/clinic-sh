#!/bin/bash

source ./config.sh

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

if [ ! -f "$exames_done" ]; then
    touch "$exames_done"
fi

cd auth
chmod a+x login.sh
./login.sh
