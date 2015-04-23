#Una Función (en Shell o en Perl) denominada Mover que se emplea para mover archivos

#Como va a ser llamada:
#Mover archivoAMover destino quienLoLlamo
#Ejemplo: Mover /root/tp/SinProcesar/wasd.txt /root/tp/Procesados ProPro.sh
#NOTAR QUE Destino NO TIENE COMO CARACTER FINAL LA BARRA /

#Si Mover es llamado sin comandos avisar
if [ $# -ne 3 -a $# -ne 2 ]
then
	echo "Para utilizar Mover correctamente:"
	echo "Mover ArchivoAMover Destino QuienHaceLaLlamada(opcional)"
	#registrando en el log
	echo "Comando Mover fue mal utilizado" >> log.txt
	exit 1
fi

#Aca tengo que poner en variables los directorios de origen y destino
ORIGENDIR=$(dirname "$1")
ORIGENFILE=$(basename "$1")

#Si el origen y el destino son iguales, no mover y registrar en el log el error
if [ "$ORIGENDIR" = "$2" ]
then
	echo "Origen y destino iguales."
	#registro esto en el log
	if [ $# -eq 3 ]
	then
		echo "Comando Mover fue utilizado con origen igual a destino. Llamado por $3" >> log.txt
	fi
	exit 0
fi

#Si el origen no existe, no mover y registrar en el log el error
if [ ! -d "$ORIGENDIR" ]
then
	echo "No existe el directorio especificado en Origen, no se ha movido el archivo"
	#registro esto en el log
	if [ $# -eq 3 ]
	then
		echo "Mover llamado con directorio Origen inexistente por llamador. Archivo $1 no movido. Llamado por $3" >> log.txt
	fi
	exit 1
fi

#Si el destino no existe, no mover y registrar en el log el error
if [ ! -d "$2" ]
then
	echo "No existe el directorio especificado en Destino, no se ha movido el archivo"
	#registro esto en el log
	if [ $# -eq 3 ]
	then
		echo "Mover llamado con directorio Destino inexistente por llamador. Archivo $1 no movido. Llamado por $3" >> log.txt
	fi
	exit 1
fi

#También debo fijarme si en verdad existe el archivo donde digo que está
if [ ! -f "$1" ]
then
	echo "No existe el archivo especificado en el Origen"
	exit 1
fi

#si en el destino ya existe otro archivo con el mismo nombre (nombre de archivo duplicado),
#no debe fracasar la operación, la función debe poder conservar ambos.
#Aca hago que tengo para ver si existe el archivo
FILEDESTINY="$2""/""$ORIGENFILE"
#Me fijo que no exista y luego lo paso
if [ ! -f "$FILEDESTINY" ]
then
	mv "$1" "$FILEDESTINY"
else
	FLAGENTER=0
	COUNTERLAST=0
	COUNTERMIDDLE=0
	COUNTERFIRST=0
	#Esta direccion tiene que venir de algun lado, variable de entorno padre, al llamar o algo
	DUPLICATEDDIRECTORY='/home/fdc/Documents/SistemasOperativos/Trabajo Práctico/SisProH/DUPDIR'
	DUPLICATEDDIRECTORYDESTINY="$DUPLICATEDDIRECTORY""/""$ORIGENFILE"".""$COUNTERFIRST""$COUNTERMIDDLE""$COUNTERLAST"
	#Me fijo si ya existe uno con esos
	if [ ! -f "$DUPLICATEDDIRECTORYDESTINY" ]
	then
		mv "$1" "$DUPLICATEDDIRECTORYDESTINY"
		echo "Archivo movido a la carpeta $DUPLICATEDDIRECTORY bajo el nombre: $ORIGENFILE.$COUNTERFIRST$COUNTERMIDDLE$COUNTERLAST"
	else
		while [ "$FLAGENTER" -eq 0 ]
		do
			if [ "$COUNTERLAST" -ge 9 ]
			then
				COUNTERLAST=0
				if [ "$COUNTERMIDDLE" -ge 9 ]
				then
					COUNTERMIDDLE=0
					((COUNTERFIRST++))
				else
					((COUNTERMIDDLE++))
				fi
			else
				((COUNTERLAST++))
			fi

			#Ahora va a tener los numeros actualizados
			DUPLICATEDDIRECTORYDESTINY="$DUPLICATEDDIRECTORY""/""$ORIGENFILE"".""$COUNTERFIRST""$COUNTERMIDDLE""$COUNTERLAST"
			#Y me fijo nuevamente a ver si no existe, si no existe, genial
			if [ ! -f "$DUPLICATEDDIRECTORYDESTINY" ]
			then
				mv "$1" "$DUPLICATEDDIRECTORYDESTINY"
				echo "Archivo movido a la carpeta $DUPLICATEDDIRECTORY bajo el nombre: $ORIGENFILE.$COUNTERFIRST$COUNTERMIDDLE$COUNTERLAST"
				FLAGENTER=1
			fi
		done
	fi

fi