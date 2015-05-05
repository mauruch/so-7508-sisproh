#!/bin/bash
#Comando para la configuración inicial del entorno de ejecución del Sistema

export GRUPO=$HOME/GRUPO06
export CONFDIR=$GRUPO/conf
INSPROCONF="$CONFDIR/InsPro.conf"
chmod +x $GRUPO/Glog.sh
chmod +rw $INSPROCONF

#Verifico que no este corriendo un proceso IniPro.sh
if pgrep "IniPro.sh"
then
	echo "El proceso IniPro.sh ya ha sido ejecutado y se encuentra corriendo"
	$GRUPO/Glog.sh "$0" 'El proceso IniPro.sh ya ha sido ejecutado y se encuentra corriendo' 'ERR'
	exit 1
fi



#Verifico que las variables de ambiente no esten ya seteadas
#Seteo variables de entorno tomadas del archivo InsPro.conf

#BINDIR=/faf/
################################################################################################
################################## SETEO VARIABLES DE ENTORNO  #################################
################################################################################################

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

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE LOGDIR Y SUS ARCHIVOS
LOGDIR=$(grep "LOGDIR" "$INSPROCONF")
export $LOGDIR



#Seteo variable PATH
export PATH="$2" #TODO:review


array_key=( "$CONFDIR" "$BINDIR" "$MAEDIR" "$NOVEDIR" "$DATASIZE" "$ACEPDIR" "$RECHDIR" "$PROCDIR" "$INFODIR" "$DUPDIR" "$LOGDIR" "$LOGSIZE" )

array_value=( "Directorio de Configuración" "Directorio de Ejecutables" "Directorio de Maestros y Tablas" "Directorio de recepción de documentos para protocolización" "Espacio mínimo libre para arribos [Mb]" "Directorio de Archivos Aceptados" "Directorio de Archivos Rechazados" "Directorio de Archivos Protocolizados" "Directorio para informes y estadísticas" "Nombre para el repositorio de duplicados" "Directorio para Archivos de Log" "Tamaño máximo para los archivos de log del sistema [Kb]")

elements=${#array_key[@]}

for (( i=0;i<$elements;i++ )); do

	KEY=${array_key[${i}]}

	echo -e "${array_value[${i}]}: $KEY \n"

	#listar los archivos cuando es necesario 
	if [ "$KEY" = "$CONFDIR" ] || [ "$KEY" = "$BINDIR" ] || [ "$KEY" = "$MAEDIR" ]	|| [ "$KEY" = "$LOGDIR" ] ; then
		echo "TRATANDO DE LISTAR: $KEY"
		ls "$KEY"
	fi
	
done

echo -e "\n"

################################################################################################
############################## FIN DE SETEO VARIABLES DE ENTORNO  ##############################
################################################################################################



################################################################################################
#################### VERIFICACIONES DE SCRIPTS, ARCHIVOS MAESTROS Y TABLAS #####################
################################################################################################
#Shell Scripts
VERIFYRECPRO="$BINDIR""/RecPro.sh"
VERIFYPROPRO="$BINDIR""/ProPro.sh"
#Perl script
VERIFYINFPRO="$BINDIR""/InfPro.pl"
#Archivos maestros
VERIFYEMISORES="$MAEDIR""/emisores.mae"
VERIFYNORMAS="$MAEDIR""/normas.mae"
VERIFYGESTIONES="$MAEDIR""/gestiones.mae"
#Tablas
VERIFYNXE="$MAEDIR""/tab/nxe.tab"
VERIFYAXG="$MAEDIR""/tab/axg.tab"

if [ ! -f "$VERIFYRECPRO" ]
then
	echo "No existe el script $VERIFYRECPRO, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "$0" "No existe el script $VERIFYRECPRO, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	if [ ! -x "$VERIFYRECPRO" ]; then
		echo "$VERIFYRECPRO no tiene permisos de ejecucion, se procede a setearselos"
		$GRUPO/Glog.sh "$0" "$VERIFYRECPRO no tiene permisos de ejecucion, se procede a setearselos" 'INFO'
		chmod +x "$VERIFYRECPRO"
	fi
fi

if [ ! -f "$VERIFYPROPRO" ]
then
	echo "No existe el script $VERIFYPROPRO, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "$0" "No existe el script $VERIFYPROPRO, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	if [ ! -x "$VERIFYPROPRO" ]; then
		echo "$VERIFYPROPRO no tiene permisos de ejecucion, se procede a setearselos"
		$GRUPO/Glog.sh "$0" "$VERIFYPROPRO no tiene permisos de ejecucion, se procede a setearselos" 'INFO'
		chmod +x "$VERIFYPROPRO"
	fi
fi

if [ ! -f "$VERIFYINFPRO" ]
then
	echo "No existe el perl script $VERIFYINFPRO, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "$0" "No existe el script $VERIFYINFPRO, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	if [ ! -x "$VERIFYINFPRO" ]; then
		echo "$VERIFYINFPRO no tiene permisos de ejecucion, se procede a setearselos"
		$GRUPO/Glog.sh "$0" "$VERIFYINFPRO no tiene permisos de ejecucion, se procede a setearselos" 'INFO'
		chmod +x "$VERIFYINFPRO"
	fi
fi

if [ ! -f "$VERIFYEMISORES" ]
then
	echo "No existe el archivo $VERIFYEMISORES, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "$0" "No existe el archivo $VERIFYEMISORES, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYEMISORES"
fi

if [ ! -f "$VERIFYNORMAS" ]
then
	echo "No existe el archivo $VERIFYNORMAS, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "$0" "No existe el archivo $VERIFYNORMAS, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYNORMAS"
fi

if [ ! -f "$VERIFYGESTIONES" ]
then
	echo "No existe el archivo $VERIFYGESTIONES, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "$0" "No existe el archivo $VERIFYGESTIONES, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYGESTIONES"
fi

if [ ! -f "$VERIFYNXE" ]
then
	echo "No existe el archivo $VERIFYNXE, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "$0" "No existe el archivo $VERIFYNXE, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYNXE"
fi

if [ ! -f "$VERIFYAXG" ]
then
	echo "No existe el archivo $VERIFYAXG, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "$0" "No existe el archivo $VERIFYAXG, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYAXG"
fi
################################################################################################
##################################### FIN DE VERIFICACIONES  ###################################
################################################################################################



echo "Estado del Sistema: INICIALIZADO"
$GRUPO/Glog.sh "$0" "Estado del Sistema: INICIALIZADO" 'INFO'

preguntarActivarRecPro()
{
	read -p "Desea efectuar la activación de RecPro? si/no luego [ENTER]: " activarRecPro
	if [ "$activarRecPro" = "si" ]; then
		if pgrep "RecPro.sh"
		then
			#TODO: Ver si esta bien explicado como correr el Stop.sh
			echo "El proceso RecPro.sh ya ha sido ejecutado y se encuentra corriendo."
			echo "Para detener el proceso RecPro activo, ejecute el comando ./Stop.sh"
			$GRUPO/Glog.sh "$0" 'El proceso RecPro.sh ya ha sido ejecutado y se encuentra corriendo' 'ERR'
			exit 1
		else
			$BINDIR/RecPro.sh
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
$GRUPO/Glog.sh "$0" "RecPro corriendo bajo el no.: $RECPROPROCESSID" 'INFO'
