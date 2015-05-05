#!/bin/bash
#Comando para la configuración inicial del entorno de ejecución del Sistema
export GRUPO=$HOME/GRUPO06
export CONFDIR=$GRUPO/conf
INSPROCONF="$CONFDIR/InsPro.conf"
chmod +x $GRUPO/Glog.sh
chmod +rw $INSPROCONF

LOGDIR=$(grep "LOGDIR" "$INSPROCONF")
export $LOGDIR


################################################################################################
################ VERIFICO SI LAS VARIABLES DE AMBIENTE YA ESTAN SETEADAS  ######################
################################################################################################

continuo_proceso_iniPro="false"
array_key=( "$CONFDIR" "$BINDIR" "$MAEDIR" "$NOVEDIR" "$DATASIZE" "$ACEPDIR" "$RECHDIR" "$PROCDIR" "$INFODIR" "$DUPDIR" "$LOGDIR" "$LOGSIZE" )
elements=${#array_key[@]}
for (( i=0;i<$elements;i++ )); do

	KEY=${array_key[${i}]}

	if [ "" = "$KEY" ]; then
		#Si al menos una variable de ambiente se encuentra vacia
		#debere setear el ambiente
		continuo_proceso_iniPro="true"
	fi
	
done
if [ $continuo_proceso_iniPro = "false" ]; then
	echo "Ambiente ya inicializado, si quiere reiniciar termine su sesión e ingrese nuevamente"
	$GRUPO/Glog.sh "IniPro.sh" 'Ambiente ya inicializado, si quiere reiniciar termine su sesión e ingrese nuevamente' 'ERR'
	exit 1
fi
################################################################################################




################################################################################################
################################## SETEO VARIABLES DE ENTORNO  #################################
################################################################################################

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE LOGDIR Y SUS ARCHIVOS
echo "Expotando variable LOGDIR -> $LOGDIR"
$GRUPO/Glog.sh "IniPro.sh" "Expotando variable LOGDIR -> $LOGDIR" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE BINDIR Y SUS ARCHIVOS
BINDIR=$(grep "BINDIR" "$INSPROCONF")
echo "Expotando variable BINDIR -> $BINDIR"
export $BINDIR
$GRUPO/Glog.sh "IniPro.sh" "Expotando variable BINDIR -> $BINDIR" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE MAEDIR Y SUS ARCHIVOS
MAEDIR=$(grep "MAEDIR" "$INSPROCONF")
echo "Expotando variable MAEDIR -> $MAEDIR"
export $MAEDIR
$GRUPO/Glog.sh "IniPro.sh" "Expotando variable MAEDIR -> $MAEDIR" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE NOVEDIR
NOVEDIR=$(grep "NOVEDIR" "$INSPROCONF")
echo "Expotando variable NOVEDIR -> $NOVEDIR"
export $NOVEDIR
$GRUPO/Glog.sh "IniPro.sh" "Expotando variable NOVEDIR -> $NOVEDIR" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE ACEPDIR
ACEPDIR=$(grep "ACEPDIR" "$INSPROCONF")
echo "Expotando variable ACEPDIR -> $ACEPDIR"
export $ACEPDIR
$GRUPO/Glog.sh "IniPro.sh" "Expotando variable ACEPDIR -> $ACEPDIR" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE RECHDIR
RECHDIR=$(grep "RECHDIR" "$INSPROCONF")
echo "Expotando variable RECHDIR -> $RECHDIR"
export $RECHDIR
$GRUPO/Glog.sh "IniPro.sh" "Expotando variable RECHDIR -> $RECHDIR" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE PROCDIR
PROCDIR=$(grep "PROCDIR" "$INSPROCONF")
echo "Expotando variable PROCDIR -> $PROCDIR"
export $PROCDIR
$GRUPO/Glog.sh "IniPro.sh" "Expotando variable PROCDIR -> $PROCDIR" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE INFODIR
INFODIR=$(grep "INFODIR" "$INSPROCONF")
echo "Expotando variable INFODIR -> $INFODIR"
export $INFODIR
$GRUPO/Glog.sh "IniPro.sh" "Expotando variable INFODIR -> $INFODIR" 'INFO'

#MOSTRAR, LOGUEAR Y EXPORTAR VARIABLE DUPDIR
DUPDIR=$(grep "DUPDIR" "$INSPROCONF")
echo "Expotando variable DUPDIR -> $DUPDIR"
export $DUPDIR
$GRUPO/Glog.sh "IniPro.sh" "Expotando variable DUPDIR -> $DUPDIR" 'INFO'

array_key=( "$CONFDIR" "$BINDIR" "$MAEDIR" "$NOVEDIR" "$ACEPDIR" "$RECHDIR" "$PROCDIR" "$INFODIR" "$DUPDIR" "$LOGDIR" )

array_value=( "Directorio de Configuración" "Directorio de Ejecutables" "Directorio de Maestros y Tablas" "Directorio de recepción de documentos para protocolización" "Directorio de Archivos Aceptados" "Directorio de Archivos Rechazados" "Directorio de Archivos Protocolizados" "Directorio para informes y estadísticas" "Nombre para el repositorio de duplicados" "Directorio para Archivos de Log" )

elements=${#array_key[@]}

for (( i=0;i<$elements;i++ )); do

	KEY=${array_key[${i}]}

	echo -e "${array_value[${i}]}: $KEY"
	$GRUPO/Glog.sh "IniPro.sh" "${array_value[${i}]}: $KEY" 'INFO'

	#listar los archivos cuando es necesario 
	if [ "$KEY" = "$CONFDIR" ] || [ "$KEY" = "$BINDIR" ] || [ "$KEY" = "$MAEDIR" ]	|| [ "$KEY" = "$LOGDIR" ] ; then
		ls "$KEY"
		$GRUPO/Glog.sh "IniPro.sh" "$(ls "$KEY")" 'INFO'
	fi
	
done

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
	$GRUPO/Glog.sh "IniPro.sh" "No existe el script $VERIFYRECPRO, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	if [ ! -x "$VERIFYRECPRO" ]; then
		echo "$VERIFYRECPRO no tiene permisos de ejecucion, se procede a setearselos"
		$GRUPO/Glog.sh "IniPro.sh" "$VERIFYRECPRO no tiene permisos de ejecucion, se procede a setearselos" 'INFO'
		chmod +x "$VERIFYRECPRO"
	fi
fi

if [ ! -f "$VERIFYPROPRO" ]
then
	echo "No existe el script $VERIFYPROPRO, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "IniPro.sh" "No existe el script $VERIFYPROPRO, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	if [ ! -x "$VERIFYPROPRO" ]; then
		echo "$VERIFYPROPRO no tiene permisos de ejecucion, se procede a setearselos"
		$GRUPO/Glog.sh "IniPro.sh" "$VERIFYPROPRO no tiene permisos de ejecucion, se procede a setearselos" 'INFO'
		chmod +x "$VERIFYPROPRO"
	fi
fi

if [ ! -f "$VERIFYINFPRO" ]
then
	echo "No existe el perl script $VERIFYINFPRO, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "IniPro.sh" "No existe el script $VERIFYINFPRO, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	if [ ! -x "$VERIFYINFPRO" ]; then
		echo "$VERIFYINFPRO no tiene permisos de ejecucion, se procede a setearselos"
		$GRUPO/Glog.sh "IniPro.sh" "$VERIFYINFPRO no tiene permisos de ejecucion, se procede a setearselos" 'INFO'
		chmod +x "$VERIFYINFPRO"
	fi
fi

if [ ! -f "$VERIFYEMISORES" ]
then
	echo "No existe el archivo $VERIFYEMISORES, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "IniPro.sh" "No existe el archivo $VERIFYEMISORES, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYEMISORES"
fi

if [ ! -f "$VERIFYNORMAS" ]
then
	echo "No existe el archivo $VERIFYNORMAS, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "IniPro.sh" "No existe el archivo $VERIFYNORMAS, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYNORMAS"
fi

if [ ! -f "$VERIFYGESTIONES" ]
then
	echo "No existe el archivo $VERIFYGESTIONES, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "IniPro.sh" "No existe el archivo $VERIFYGESTIONES, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYGESTIONES"
fi

if [ ! -f "$VERIFYNXE" ]
then
	echo "No existe el archivo $VERIFYNXE, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "IniPro.sh" "No existe el archivo $VERIFYNXE, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYNXE"
fi

if [ ! -f "$VERIFYAXG" ]
then
	echo "No existe el archivo $VERIFYAXG, es necesario ejecutar el instalador InsPro.sh previamente"
	$GRUPO/Glog.sh "IniPro.sh" "No existe el archivo $VERIFYAXG, es necesario ejecutar el instalador InsPro.sh previamente" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYAXG"
fi
################################################################################################

echo "Estado del Sistema: INICIALIZADO"
$GRUPO/Glog.sh "IniPro.sh" "Estado del Sistema: INICIALIZADO" 'INFO'

preguntarActivarRecPro()
{
	read -p "Desea efectuar la activación de RecPro? si/no luego [ENTER]: " activarRecPro
	if [ "$activarRecPro" = "si" ]; then
		if pgrep "RecPro.sh"
		then
			#TODO: Ver si esta bien explicado como correr el Stop.sh
			echo "El proceso RecPro.sh ya ha sido ejecutado y se encuentra corriendo."
			echo "Para detener el proceso RecPro activo, ejecute el comando $GRUPO/Stop.sh"
			$GRUPO/Glog.sh "IniPro.sh" 'El proceso RecPro.sh ya ha sido ejecutado y se encuentra corriendo' 'ERR'
			exit 1
		else
			$BINDIR/RecPro.sh
			RECPROPROCESSID=$(/bin/ps -fu $USER | grep "RecPro.sh" | grep -v "grep" | awk '{print $2}')
			echo "RecPro corriendo bajo el no.: $RECPROPROCESSID"
			$GRUPO/Glog.sh "IniPro.sh" "RecPro corriendo bajo el no.: $RECPROPROCESSID" 'INFO'
			exit 1
		fi
	elif [ "$activarRecPro" = "no" ]; then
		#TODO: Ver si esta bien explicado como correr el Start.sh
		echo "Usted no ha querido ejecutar el proceso RecPro.sh."
		echo "Podra ejecutarlo luego corriendo el proceso $GRUPO/Start.sh"
		exit 1
	else
		echo "$activarRecPro no es un comando valido."
		preguntarActivarRecPro
	fi
}
preguntarActivarRecPro


