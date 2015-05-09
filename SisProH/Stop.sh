#!/bin/bash

#Shell script para detener procesos
#Uso: Stop.sh nombreFunción

functionToStop="$(ps -a | grep "$1" | awk '{print $1}')"

if [ "$functionToStop" = '' ]
then
	echo "No se hay encontrado el proceso $1 corriendo"
else
	echo "Terminando proceso $1 con PID: $functionToStop"
	kill $(ps -a | grep "$1" | awk '{print $1}')
fi