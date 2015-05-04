#!/bin/bash
#Comando para la configuración inicial del entorno de ejecución del Sistema
#IniPro.sh archivoDeInsPro.conf directorioDeLosEjecutables directorioDeMAEDIR
#Ejemplo
#IniPro.sh /home/InsPro.conf /home/BINDIR /home/MAEDIR

INIPROSCRIPT=`basename "$0"`
chmod +x Glog.sh
#Verifico que no este corriendo un proceso IniPro.sh
if pgrep "IniPro.sh"
then
	echo "El proceso IniPro.sh ya ha sido ejecutado y se encuentra corriendo"
	./Glog.sh "$0" 'El proceso IniPro.sh ya ha sido ejecutado y se encuentra corriendo' 'ERR'
	exit 1
fi

#Veo que IniPro.sh sea llamado correctamente
if [ $# -ne 3 ]
then
	echo "Para utilizar IniPro.sh correctamente:"
	echo "IniPro archivoDeInsPro.conf directorioDeLosEjecutables directorioDeMAEDIR"
	#registrando en el log
	./Glog.sh "$0" 'Comando fue mal utilizado' 'ERR'
	exit 1
fi

#Verifico que lo que me pasaron como InsPro.conf exista
if [ ! -f "$1" ]
then
	echo "No existe el archivo $1"
	./Glog.sh "$0" "No existe $1" 'ERR'
	exit 1
else
	#Me fijo que el archivo que me hayan pasado por lo menos se llame InsPro.conf
	CONFFILE=$(basename "$1")
	if [ "$1" != "InsPro.conf" ]
	then
		echo "El archivo pasado no es InsPro.conf"
		./Glog.sh "$0" "$1 archivo pasado, se esperaba InsPro.conf" 'ERR'
		exit 1
	fi
fi

#Verifico que las variables de ambiente no esten ya seteadas
#Seteo variables de entorno tomadas del archivo InsPro.conf
INSPROCONF="$1"
while read line
do
	IFS='=' read VAR PATH <<< "$CONFDIR"
	if [ -n "$VAR" ]; then
		echo "ambiente ya inicializado, si quiere reiniciar termine su sesión e ingrese nuevamente"
		./Glog.sh "$0" 'ambiente ya inicializado, si quiere reiniciar termine su sesión e ingrese nuevamente' 'ERR'
		exit 1
	fi  
done < $INSPROCONF

################################################################################################
#################### VERIFICACIONES DE SCRIPTS, ARCHIVOS MAESTROS Y TABLAS #####################
################################################################################################
#Shell Scripts
VERIFYRECPRO="$2""/RecPro.sh"
VERIFYPROPRO="$2""/ProPro.sh"
#Perl script
VERIFYINFPRO="$2""/InfPro.pl"
#Archivos maestros
VERIFYEMISORES="$3""/emisores.mae"
VERIFYNORMAS="$3""/normas.mae"
VERIFYGESTIONES="$3""/gestiones.mae"
#Tablas
VERIFYNXE="$3""/tab/nxe.tab"
VERIFYAXG="$3""/tab/axg.tab"

if [ ! -f "$VERIFYRECPRO" ]
then
	echo "No existe el script $VERIFYRECPRO, es necesario ejecutar el instalador InsPro.sh previamente"
	./Glog.sh "$0" "No existe el script $VERIFYRECPRO, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	if [ ! -x "$VERIFYRECPRO" ]; then
		echo "$VERIFYRECPRO no tiene permisos de ejecucion, se procede a setearselos"
		./Glog.sh "$0" "$VERIFYRECPRO no tiene permisos de ejecucion, se procede a setearselos" 'INFO'
		chmod +x "$VERIFYRECPRO"
	fi
fi

if [ ! -f "$VERIFYPROPRO" ]
then
	echo "No existe el script $VERIFYPROPRO, es necesario ejecutar el instalador InsPro.sh previamente"
	./Glog.sh "$0" "No existe el script $VERIFYPROPRO, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	if [ ! -x "$VERIFYPROPRO" ]; then
		echo "$VERIFYPROPRO no tiene permisos de ejecucion, se procede a setearselos"
		./Glog.sh "$0" "$VERIFYPROPRO no tiene permisos de ejecucion, se procede a setearselos" 'INFO'
		chmod +x "$VERIFYPROPRO"
	fi
fi

if [ ! -f "$VERIFYINFPRO" ]
then
	echo "No existe el perl script $VERIFYINFPRO, es necesario ejecutar el instalador InsPro.sh previamente"
	./Glog.sh "$0" "No existe el script $VERIFYINFPRO, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	if [ ! -x "$VERIFYINFPRO" ]; then
		echo "$VERIFYINFPRO no tiene permisos de ejecucion, se procede a setearselos"
		./Glog.sh "$0" "$VERIFYINFPRO no tiene permisos de ejecucion, se procede a setearselos" 'INFO'
		chmod +x "$VERIFYINFPRO"
	fi
fi

if [ ! -f "$VERIFYEMISORES" ]
then
	echo "No existe el archivo $VERIFYEMISORES, es necesario ejecutar el instalador InsPro.sh previamente"
	./Glog.sh "$0" "No existe el archivo $VERIFYEMISORES, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYEMISORES"
fi

if [ ! -f "$VERIFYNORMAS" ]
then
	echo "No existe el archivo $VERIFYNORMAS, es necesario ejecutar el instalador InsPro.sh previamente"
	./Glog.sh "$0" "No existe el archivo $VERIFYNORMAS, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYNORMAS"
fi

if [ ! -f "$VERIFYGESTIONES" ]
then
	echo "No existe el archivo $VERIFYGESTIONES, es necesario ejecutar el instalador InsPro.sh previamente"
	./Glog.sh "$0" "No existe el archivo $VERIFYGESTIONES, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYGESTIONES"
fi

if [ ! -f "$VERIFYNXE" ]
then
	echo "No existe el archivo $VERIFYNXE, es necesario ejecutar el instalador InsPro.sh previamente"
	./Glog.sh "$0" "No existe el archivo $VERIFYNXE, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYNXE"
fi

if [ ! -f "$VERIFYAXG" ]
then
	echo "No existe el archivo $VERIFYAXG, es necesario ejecutar el instalador InsPro.sh previamente"
	./Glog.sh "$0" "No existe el archivo $VERIFYAXG, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYAXG"
fi
################################################################################################
##################################### FIN DE VERIFICACIONES  ###################################
################################################################################################


################################################################################################
################################## SETEO VARIABLES DE ENTORNO  #################################
################################################################################################
INSPROCONF="$1"

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE CONFDIR Y SUS ARCHIVOS
CONFDIR=$(grep "CONFDIR" "$INSPROCONF")
export $CONFDIR
IFS='=' read var path <<< "$CONFDIR"
LISTARCHCONFDIR=$(ls $path)
echo "Directorio de Configuración: $var - path=$path - lista de archivos=$LISTARCHCONFDIR"
./Glog.sh "$0" "Directorio de Configuración: $var - path=$path - lista de archivos=$LISTARCHCONFDIR" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE BINDIR Y SUS ARCHIVOS
BINDIR=$(grep "BINDIR" "$INSPROCONF")
export $BINDIR
IFS='=' read var path <<< "$BINDIR"
LISTARCHBINDIR=$(ls $path)
echo "Directorio de Ejecutables: $var - path=$path - lista de archivos=$LISTARCHBINDIR"
./Glog.sh "$0" "Directorio de Ejecutables: $var - path=$path - lista de archivos=$LISTARCHBINDIR" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE MAEDIR Y SUS ARCHIVOS
MAEDIR=$(grep "MAEDIR" "$INSPROCONF")
export $MAEDIR
IFS='=' read var path <<< "$MAEDIR"
LISTARCHMAEDIR=$(ls $path)
echo "Directorio de Maestros y Tablas: $var - path=$path - lista de archivos=$LISTARCHMAEDIR"
./Glog.sh "$0" "Directorio de Maestros y Tablas: $var - path=$path - lista de archivos=$LISTARCHMAEDIR" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE NOVEDIR
NOVEDIR=$(grep "NOVEDIR" "$INSPROCONF")
export $NOVEDIR
IFS='=' read var path <<< "$NOVEDIR"
echo "Directorio de recepción de documentos para protocolización: $var"
./Glog.sh "$0" "Directorio de recepción de documentos para protocolización: $var" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE ACEPDIR
ACEPDIR=$(grep "ACEPDIR" "$INSPROCONF")
export $ACEPDIR
IFS='=' read var path <<< "$ACEPDIR"
echo "Directorio de Archivos Aceptados: $var"
./Glog.sh "$0" "Directorio de Archivos Aceptados: $var" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE RECHDIR
RECHDIR=$(grep "RECHDIR" "$INSPROCONF")
export $RECHDIR
IFS='=' read var path <<< "$RECHDIR"
echo "Directorio de Archivos Rechazados: $var"
./Glog.sh "$0" "Directorio de Archivos Rechazados: $var" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE PROCDIR
PROCDIR=$(grep "PROCDIR" "$INSPROCONF")
export $PROCDIR
IFS='=' read var path <<< "$PROCDIR"
echo "Directorio de Archivos Protocolizados: $var"
./Glog.sh "$0" "Directorio de Archivos Protocolizados: $var" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE INFODIR
INFODIR=$(grep "INFODIR" "$INSPROCONF")
export $INFODIR
IFS='=' read var path <<< "$INFODIR"
echo "Directorio para informes y estadísticas: $var"
./Glog.sh "$0" "Directorio para informes y estadísticas: $var" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE DUPDIR
DUPDIR=$(grep "DUPDIR" "$INSPROCONF")
export $DUPDIR
IFS='=' read var path <<< "$DUPDIR"
echo "Nombre para el repositorio de duplicados: $var"
./Glog.sh "$0" "Nombre para el repositorio de duplicados: $var" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE LOGDIR Y SUS ARCHIVOS
LOGDIR=$(grep "LOGDIR" "$INSPROCONF")
export $LOGDIR
IFS='=' read var path <<< "$LOGDIR"
LISTARCHLOGDIR=$(ls $path)
echo "Directorio para Archivos de Log: $var - path=$path - lista de archivos=$LISTARCHLOGDIR"
./Glog.sh "$0" "Directorio para Archivos de Log: $var - path=$path - lista de archivos=$LISTARCHLOGDIR" 'INFO'

#Seteo variable PATH
export PATH="$2" #TODO:review

echo "Estado del Sistema: INICIALIZADO"
./Glog.sh "$0" "Estado del Sistema: INICIALIZADO" 'INFO'

################################################################################################
############################## FIN DE SETEO VARIABLES DE ENTORNO  ##############################
################################################################################################

preguntarActivarRecPro()
{
	read -p "Desea efectuar la activación de RecPro? si/no luego [ENTER]: " activarRecPro
	if [ "$activarRecPro" = "si" ]; then
		if pgrep "RecPro.sh"
		then
			#TODO: Ver si esta bien explicado como correr el Stop.sh
			echo "El proceso RecPro.sh ya ha sido ejecutado y se encuentra corriendo."
			echo "Para detener el proceso RecPro activo, ejecute el comando ./Stop.sh"
			./Glog.sh "$0" 'El proceso RecPro.sh ya ha sido ejecutado y se encuentra corriendo' 'ERR'
			exit 1
		else
			./RecPro.sh
			exit 1
		fi
	elif [ "$activarRecPro" = "no" ]; then
		#TODO: Ver si esta bien explicado como correr el Start.sh
		echo "Usted no ha querido ejecutar el proceso RecPro.sh."
		echo "Podra ejecutarlo luego corriendo el proceso ./Start.sh"
		exit 1
	else
		echo "$activarRecPro no es un comando valido."
		preguntarActivarRecPro
	fi
}
preguntarActivarRecPro
RECPROPROCESSID=$(/bin/ps -fu $USER | grep "RecPro.sh" | grep -v "grep" | awk '{print $2}')
echo "RecPro corriendo bajo el no.: $RECPROPROCESSID"
./Glog.sh "$0" "RecPro corriendo bajo el no.: $RECPROPROCESSID" 'INFO'