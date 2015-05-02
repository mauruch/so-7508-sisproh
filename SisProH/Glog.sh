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
logPathDefault='LOGDIR/Glog.sh.txt'
#placeholder de usuario
user=$USERNAME
#Tipo de mensaje por default
defaultMessageType='INFO'
defaultCommandCaller='Glog.sh'
defaultMaxLines=500

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
	exit 1
fi

#Acá asigno los directorios
if [ $1 == 'Mover.sh' -o $1 == 'Glog.sh' -o $1 == 'Start.sh' -o $1 == 'ProPro.sh' -o $1 == 'InsPro.sh' -o $1 == 'Stop.sh' -o $1 == 'InfPro.pl' -o $1 == 'IniPro.sh' -o $1 == 'RecPro.sh' -o $1 == 'IniPro.sh' ]
then
	logPath="LOGDIR/""$1"".txt"
else		
	echo "Instrucción no reconocida"
	echo `date +%F`"|"`date +%T`" $user $defaultCommandCaller $defaultMessageType Comando Glog no reconoció el script pasado como primer parámetro" >> "$logPathDefault"
	exit 1	
fi

#Acá debería verificar que no se exceda de tanto
if [ -f "$logPath" ]
then
	lineasQueTieneElArchivo=`wc -l $logPath | cut -d ' ' -f 1`
	if [ $lineasQueTieneElArchivo -ge $defaultMaxLines ]
	then
		sed -i -e '1,450d' "$logPath"
	fi
fi


if [ $# -eq 3 ]
then
	echo `date +%F`"|"`date +%T`" $user $1 $3 $2" >> "$logPath"
	exit 0
else
	#si entro aca es porque $# -eq 2
	echo `date +%F`"|"`date +%T`" $user $1 $defaultMessageType $2" >> "$logPath"
	exit 0
fi

