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
logPathDefault='log.txt'
#placeholder de usuario
user=$USERNAME
#Tipo de mensaje por default
defaultMessageType='INFO'
defaultCommandCaller='Glog.sh'

#Si Glog es llamado sin la cantidad de comandos correctos mostrar mensaje
if [ $# -ne 3 -a $# -ne 2 ]
then
	echo "Para utilizar Glog correctamente:"
	echo "Glog ComandoQueLoLlamo 'Mensaje' TipoDeMensaje(opcional)"
	#registrando en el log
	defaultMessageType='ERR'
	echo `date +%F`"|"`date +%T`" $user $defaultCommandCaller $defaultMessageType Comando Mover fue mal utilizado" >> "$logPathDefault"
	exit 1
fi

#Acá asigno los directorios
#PELIGRO CASCADA DE IFS
#Espero no olvidarme de ninguno
if [ $1 == 'Mover.sh' -o $1 == 'Glog.sh' -o $1 == 'Start.sh' -o $1 == 'Stop.sh' -o $1 == 'InfPro.pl' -o $1 == 'IniPro.sh' -o $1 == 'RecPro.sh' -o $1 == 'IniPro.sh' ]
then
	logPath = "$logPathDefault"
else
	if [ $1 == 'ProPro.sh' ]
	then
		logPath = "/LOGDIR/ProPro"
	else
		if [ $1 == 'InsPro.sh' ]
		then
			#TODO ver donde va ese log
			logPath = "InsProLog.txt"
		else
			echo "Instrucción no reconocida"
			echo `date +%F`"|"`date +%T`" $user $defaultCommandCaller $defaultMessageType Comando Mover no reconoció el programa especificado en su primer variable" >> "$logPathDefault"
			exit 1
		fi
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

