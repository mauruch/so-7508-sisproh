#Comando de instalacion

#Lo primero que vamos a hacer sería decirle a todos los scripts que son ejecutables
#De esta forma se los va a poder llamar de esta forma `./Mover.sh`
chmod +x InsPro.sh
chmod +x Glog.sh
chmod +x InfPro.pl
chmod +x IniPro.sh
chmod +x Mover.sh
chmod +x ProPro.sh
chmod +x RecPro.sh
chmod +x Start.sh
chmod +x Stop.sh

#Luego faltaría agregarle el archivo de configuracion

#!/bin/bash

export GRUPO=/home/mauro/developer/grupo06
export CONFDIR="$GRUPO/conf"



#checkeo si esta instalado
#checkInstallation

#se crea el log de la instalacion
insproLog="$CONFDIR/InsPro.log"
if [ ! -f $insproLog ]; then
    touch $insproLog
fi

sh Glog.sh "Inicio de la Ejecución de InsPro" "INFO"
sh Glog.sh "Directorio predefinido de Configuracion: $CONFDIR" "INFO"
sh Glog.sh "Log de la instalación: $insproLog" "INFO"

echo "** Bienvenido al sistema de Protocolizacion ** "
echo "Lo ayudaremos en el proceso de instalacion del mismo..."

array_key=( "BINDIR" "MAEDIR" "NOVEDIR" "DATASIZE" "ACEPDIR" "RECHDIR" "PROCDIR" "INFODIR" "DUPDIR" "LOGDIR" "LOGSIZE" )

array_value=( "el directorio para los ejecutables" "el directorio para los maestros y tablas" "el directorio de recepcion de documentos para la protocolizacion" "espacio mínimo libre para el arribo de estas novedades en Mbytes" "el directorio de grabación de las Novedades aceptadas" "el directorio de grabación de archivos rechazados" "el directorio de grabación de los documentos protocolizados" "el directorio de grabación de los informes de salida" "el nombre para el repositorio de archivos duplicados" "el directorio de logs" "el tamaño máximo para cada archivo de log en Kbytes" )

array_default=( "$GRUPO/bin" "$GRUPO/mae" "$GRUPO/novedades" "100" "$GRUPO/a_protocolizar" "$GRUPO/rechazados" "$GRUPO/protocolizados" "$GRUPO/informes" "$GRUPO/dup" "$GRUPO/log" "400" )

elements=${#array_key[@]}

for (( i=0;i<$elements;i++)); do

    echo "Defina ${array_value[${i}]} (${array_default[${i}]}):"
	read input

	KEY=${array_key[${i}]}

	#si presiona ENTER se seta el default
	if [ "$input" = "" ]; then
    	KEY="${array_default[${i}]}"
	else
    	KEY="$GRUPO/$input"
	fi
	echo $KEY
	#si no existe el dir se crea
	if [ ! -d $KEY ]; then
    	mkdir $KEY
	fi

	# se loguea la accion
	sh Glog.sh "Se estableció ${array_value[${i}]}: $KEY" "INFO"

done 


#instalacion exitosa
touch $CONFDIR/InsPro.conf

