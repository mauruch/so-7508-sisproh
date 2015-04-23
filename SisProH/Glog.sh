#Una Función (en Shell o en Perl) denominada Glog que se emplea para grabar los archivos de log


#Como va a ser llamada:
#Glog ComandoQueLoLlamo 'Mensaje' TipoDeMensaje(opcional)
#Ejemplo: Glog Mover.sh 'Moviendo archivo tal a tal lado' 'INF'



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
logPath='log.txt'
#placeholder de usuario
user=$USERNAME
#Tipo de mensaje por default
defaultMessageType='INF'
defaultCommandCaller='Glog.sh'

#Si Glog es llamado sin la cantidad de comandos correctos mostrar mensaje
if [ $# -ne 3 -a $# -ne 2 ]
then
	echo "Para utilizar Glog correctamente:"
	echo "Glog ComandoQueLoLlamo 'Mensaje' TipoDeMensaje(opcional)"
	#registrando en el log
	defaultMessageType='ERR'
	echo `date +%F`"|"`date +%T`" $user $defaultCommandCaller $defaultMessageType Comando Mover fue mal utilizado" >> "$logPath"
	exit 1
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

