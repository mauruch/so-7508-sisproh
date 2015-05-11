#!/bin/bash

#Shell script para detener procesos
#Uso: Stop.sh nombreFunción

if [ $# -ne 1 ]
then
	echo ""
	echo -e '\t'"Stop llamado incorrectamente, se utiliza de la siguiente manera:"
	echo -e '\t'">bash Stop.sh nombreProcesoATerminar"
	exit 1
fi

functionToStop="$(ps -a | grep "$1$" | awk '{print $1}')"
echo $functionToStop

if [ "$functionToStop" = '' ]
then
	echo "No se hay encontrado el proceso $1 corriendo"
else
	echo "Terminando proceso $1 con PID: $functionToStop"
	kill $(ps -a | grep "$1" | awk '{print $1}')
fi