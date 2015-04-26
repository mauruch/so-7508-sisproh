#Comando para la configuración inicial del entorno de ejecución del Sistema

#Lo que hace este shell es crear todas las variables y tirarle export para que despues las usen sin problema

#Creo que funciona asi
#IniPro.sh archivoDeInsPro.conf directorioDeLosEjecutables directorioDeMAEDIR
#Ejemplo
#IniPro.sh /home/InsPro.conf /home/BINDIR /home/MAEDIR
#NOTAR QUE LOS DIRECTORIOS NO TIENEN EL SLASH FINAL ONDA: "directorio/lugar"

#Veo que IniPro.sh sea llamado bien
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

################################################################################################
###################### VERIFICACIONES ABURRIDAS, EL CODIGO CONTINUA ABAJO ######################
################################################################################################

#Verifico que lo que me pasaron como directorioDeMAEDIR tenga todo lo que espero que tenga
VERIFYEMISORES="$3""/emisores.mae"
VERIFYNORMAS="$3""/normas.mae"
VERIFYGESTIONES="$3""/gestiones.mae"
VERIFYNXE="$3""/tab/nxe.tab"
VERIFYAXG="$3""/tab/axg.tab"

if [ ! -f "$VERIFYEMISORES" ]
then
	echo "No existe el archivo $VERIFYEMISORES"
	./Glog.sh "$0" "No existe el archivo $VERIFYEMISORES" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYEMISORES"
fi

if [ ! -f "$VERIFYNORMAS" ]
then
	echo "No existe el archivo $VERIFYNORMAS"
	./Glog.sh "$0" "No existe el archivo $VERIFYNORMAS" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYNORMAS"
fi

if [ ! -f "$VERIFYGESTIONES" ]
then
	echo "No existe el archivo $VERIFYGESTIONES"
	./Glog.sh "$0" "No existe el archivo $VERIFYGESTIONES" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYGESTIONES"
fi

if [ ! -f "$VERIFYNXE" ]
then
	echo "No existe el archivo $VERIFYNXE"
	./Glog.sh "$0" "No existe el archivo $VERIFYNXE" 'ERR'
	exit 1
else
	chmod +rw "$VERIFYNXE"
fi

if [ ! -f "$VERIFYAXG" ]
then
	echo "No existe el archivo $VERIFYAXG"
	./Glog.sh "$0" "No existe el archivo $VERIFYAXG" 'ERR'
	exit 1
else
	chmod +rw "VERIFYAXG"
fi
################################################################################################
################################ FIN DE VERIFICACIONES ABURRIDAS ###############################
################################################################################################