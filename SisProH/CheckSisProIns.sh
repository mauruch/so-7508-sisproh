#!/bin/bash

INSPROCONF=$CONFDIR/InsPro.conf
head_msg="TP SO7508 Primer Cuatrimestre 2015. Tema H Copyright © Grupo 06"

echo $head_msg
bash $GRUPO/Glog.sh "InsPro.sh" "$head_msg"
echo -e "\n"


#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE BINDIR Y SUS ARCHIVOS
BINDIR=$(grep "BINDIR" "$INSPROCONF")
export $BINDIR

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE MAEDIR Y SUS ARCHIVOS
MAEDIR=$(grep "MAEDIR" "$INSPROCONF")
export $MAEDIR

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE NOVEDIR
NOVEDIR=$(grep "NOVEDIR" "$INSPROCONF")
export $NOVEDIR

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE ACEPDIR
ACEPDIR=$(grep "ACEPDIR" "$INSPROCONF")
export $ACEPDIR

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE RECHDIR
RECHDIR=$(grep "RECHDIR" "$INSPROCONF")
export $RECHDIR

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE PROCDIR
PROCDIR=$(grep "PROCDIR" "$INSPROCONF")
export $PROCDIR

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE INFODIR
INFODIR=$(grep "INFODIR" "$INSPROCONF")
export $INFODIR

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE DUPDIR
DUPDIR=$(grep "DUPDIR" "$INSPROCONF")
export $DUPDIR

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE LOGDIR
LOGDIR=$(grep "LOGDIR" "$INSPROCONF")
export $LOGDIR

componentsMissing=()

array_key=( "CONFDIR" "BINDIR" "MAEDIR" "NOVEDIR" "ACEPDIR" "RECHDIR" "PROCDIR" "INFODIR" "DUPDIR" "LOGDIR" )

array_value=( "Directorio de Configuración" "Directorio de Ejecutables" "Directorio de Maestros y Tablas" "Directorio de recepción de documentos para protocolización" "Directorio de Archivos Aceptados" "Directorio de Archivos Rechazados" "Directorio de Archivos Protocolizados" "Directorio para informes y estadísticas" "Nombre para el repositorio de duplicados" "Directorio para Archivos de Log")

elements=${#array_key[@]}

for (( i=0;i<$elements;i++ )); do

	KEY=${array_key[${i}]}
	eval finalDir=\${"$KEY"}

	echo -e "${array_value[${i}]}: $finalDir \n"
	bash $GRUPO/Glog.sh "InsPro.sh" "${array_value[${i}]}: $finalDir"

	if [ ! -d "$finalDir" ]; then
		componentsMissing+=($KEY)
	fi

	#listar los archivos cuando es necesario 
	if [ "$KEY" = "CONFDIR" ] || [ "$KEY" = "BINDIR" ] || [ "$KEY" = "MAEDIR" ]	|| [ "$KEY" = "LOGDIR" ] ; then
		ls "$finalDir"
		bash $GRUPO/Glog.sh "InsPro.sh" "$(ls "$finalDir")" 'INFO'
	fi

done

######### 4. Completar la instalación #################

e=${#componentsMissing[@]}
if [ ! $e -eq 0 ]; then
	echo "Estado de la instalación: INCOMPLETA"
	echo "Componentes faltantes:"
	for (( i=0;i<$e;i++ )); do
		KEY=${componentsMissing[${i}]}
		eval finalDir=\${"$KEY"}
		echo "$finalDir"
	done
	echo "Desea completar la instalación? (s/n)"
	read input

	while [ "$input" != "s" ] && [ "$input" != "n" ] 
	do
		echo "Ingreso inválido... Inicia la instalación? (s/n)"
		read input
	done

	if [ "$input" == "s" ]; then
	
		echo "Iniciando Instalación. Esta Ud. seguro? (s/n)"		
		read input		

		while [ "$input" != "s" ] && [ "$input" != "n" ] 
		do
			echo "Ingreso inválido... Inicia la instalación? (s/n)"
			read input
		done

		if [ "$input" == "s" ]; then

			echo "Creando Estructuras de directorio...."

			for (( i=0;i<e;i++)); do
				k="${componentsMissing[$i]}"
				eval finalDir=\${"$k"}
		
				#si no existe el dir se crea
				if [ ! -d $finalDir ]; then
						mkdir $finalDir
						echo "$finalDir"
				
					if [ "$k" = "MAEDIR" ]; then
						mkdir "$finalDir/tab"
						echo "$finalDir/tab"
						mkdir "$finalDir/tab/ant"
						echo "$finalDir/tab/ant"
					fi
					if [ "$k" = "PROCDIR" ]; then
						mkdir "$finalDir/proc"
						echo "$finalDir/proc"
					fi
				fi
		
			done

				echo -e "\n"
				echo -e "Instalando Archivos Maestros y Tablas \n"
				bash $GRUPO/Glog.sh "InsPro.sh" "Instalando Archivos Maestros y Tablas"

				#Nombre de la carpeta que contiene los datos
				dataDir="2015-1C-Datos/"

				###### 20.2 mueven los archivos maestros #######
				lsMaeResult=`ls $dataDir | grep '\.mae$'`
	
				for f in $lsMaeResult; do
	
					bash $GRUPO/Mover.sh "$dataDir$f" "$MAEDIR" "InsPro.sh"
				done

				###### 20.2  Se mueven los archivos tablas #######
				lsTabResult=`ls $dataDir | grep '\.tab$'`

				for f in $lsTabResult; do
	
				  bash $GRUPO/Mover.sh "$dataDir$f" "$MAEDIR/tab" "InsPro.sh"
				done

				###### 20.3 Mover los ejecutables y funciones  #######
				echo -e "Instalando Programas y Funciones \n"
				bash $GRUPO/Glog.sh "InsPro.sh" "Instalando Programas y Funciones"
				lsScriptsResult=`ls | grep '\.\(sh\|pl\)$'`
				currentDirectory=`pwd`
				for f in $lsScriptsResult; do
				  if [ $f != "Glog.sh" ] && [ $f != "Mover.sh" ] && [ $f != "InsPro.sh" ] && [ $f != "CheckSisProIns.sh" ]; then  
						bash $GRUPO/Mover.sh "$currentDirectory/$f" "$BINDIR" "InsPro.sh"
				  fi
				done
				echo "Instalación CONCLUIDA"

		fi	
	else
		exit 1
	fi

##### instalación completa ########

else
	echo -e "Proceso de Instalción Cancelado \n"
	bash $GRUPO/Glog.sh "InsPro.sh" "Proceso de Instalción Cancelado"
	exit 1
fi



