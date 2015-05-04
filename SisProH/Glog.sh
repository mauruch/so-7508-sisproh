#Una Función (en Shell o en Perl) denominada Glog que se emplea para grabar los archivos de log


#Como va a ser llamada:
#Glog ComandoQueLoLlamo 'Mensaje' TipoDeMensaje(opcional)
#Ejemplo: Glog Mover.sh 'Moviendo archivo tal a tal lado' 'INFO'

#INFO = INFORMATIVO: mensajes explicativos sobre el curso de ejecución del comando. Ejemplo: funciona todo joya
#WAR = WARNING: mensajes de advertencia pero que no afectan la continuidad de ejecución. Ejemplo: archivo duplicado
#ERR = ERROR: mensajes de error Ej: Archivo Inexistente.



#Acá deberíamos sacar el path de algún archivo que deje la instalación
#Para poder saber el directorio donde vamos a dejar los logs
#
#hacer un grep o algo del archivo que tenga esos datos que este en el mismo directorio
#del glog asi se saca mas facil y luego poner eso grepeado en el logPath
#logPath=
#
#aca logPath tendria, por ejemplo /home/user/SisProH/logs/log.txt
#
#

#creo un placeholder para que lo escriba en el mismo directorio
logPathDefault=$LOGDIR/$insproLog
#placeholder de usuario
user=$USERNAME

#Tipo de mensaje por default
defaultMessageType='INFO'
defaultCommandCaller='Glog.sh'
defaultMaxLines=500
tamanioArchivoLog=0
LOGEXT="log"
ERROR_PARAMETROS=-2

#Cantidad de lineas a respaldar en cada truncamiento
cantidadLineasRespaldo=15


function crear_directorio()
{
	if ! [ -d $1 ]; then
		mkdir $1
		echo "Directorio $1 creado correctamente."
		echo "`date` $user : Directorio $1 creado correctamente." >> $insproLog
	fi
return 0
}





#Si Glog es llamado sin la cantidad de comandos correctos mostrar mensaje
if [ $# -ne 3 -a $# -ne 2 ]
then
	echo "Para utilizar Glog correctamente:"
	echo "Glog ComandoQueLoLlamo 'Mensaje' TipoDeMensaje(opcional)"
	#registrando en el log
	defaultMessageType='ERR'
	echo `date +%F`"|"`date +%T`" $user $defaultCommandCaller $defaultMessageType Comando Mover fue mal utilizado" >> "$logPathDefault"
	
	lineasQueTieneElArchivo=`wc -l $logPathDefault | cut -d ' ' -f 1`	
	if [ $lineasQueTieneElArchivo -ge $defaultMaxLines ]
	then
		#Acá tengo que borrar
		sed -i -e '1,450d' "$logPathDefault"
	fi
	exit $ERROR_PARAMETROS
fi



##Verificamos que el llamado lo haga un script valido, en ese caso asignamos un nombre de archivo correspondiente
case "$1" in
	Mover.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;
	Glog.sh)
		archivoLog=$LOGDIR"/"$1".log";;
	ProPro.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;
	InsPro.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;
	Stop.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;
	RecPro.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;
	IniPro.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;

	*)
		echo `date +%F`"|"`date +%T`" $user $defaultCommandCaller $defaultMessageType Comando Glog no reconoció el script pasado como primer parámetro" >> "$logPathDefault"
		exit $ERROR_PARAMETROS ;;
esac





	
	#Si existe el archivo
	if [ -f $archivoLog ]
	then
		echo  "el di $logPathDefault hola"
		#Nos guardamos el tamaño del log
		tamanioArchivo=`stat -c %s $archivoLog`

		# Si el tamaño es menor a $LOGSIZE y no es instalacion puede que haya que recortar
		if [ $LOGSIZE ]
		then
			if [ $tamanioArchivo -eq $LOGSIZE ] || [ $tamanioArchivo -gt $LOGSIZE ]
			then
				# Se pasa a un archivo nuevo, borra el viejo y renombra
				lineas=`wc -l $archivoLog | cut -d ' ' -f 1`
					#fijar la variable cantidadLineas como de configuracion del sistema (necesario?)
				if [ $lineas -gt $cantidadLineasRespaldo ]
				then
					#echo "Se partió el archivo de log"
					logTemp=$archivoLog.temp
					touch $logTemp
					tail -q -n $cantidadLineasRespaldo $archivoLog > $logTemp
					rm $archivoLog
					mv $logTemp $archivoLog
				fi
			fi
		fi
    	else
	echo  "el di $logPathDefault hola"
		touch $archivoLog
    	fi   




if [ $# -eq 3 ]
then
	echo `date +%F`"|"`date +%T`" $user $1 $3 $2" >> "$archivoLog"
	exit 0
else
	#si entro aca es porque $# -eq 2
	echo `date +%F`"|"`date +%T`" $user $1 $defaultMessageType $2" >> "$archivoLog"
	exit 0
fi

