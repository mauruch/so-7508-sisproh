#Shell script para disparar procesos

# Descripcion: Comando que inicia la ejecucion del demonio 'RecPro'.
#. ../conf/InsPro.conf


### Variables ###
## NOTA: HAY QUE AJUSTAR LAS CARPETAS
###$LIB_DIR definir en archivo de configuracion
###$BIN_DIR es la carpeta de archivos principal donde esta RecPro por ejemplo
nombreScript=`basename "$0"`
#basename $0 te devuelve el nombre del archivo, en este caso Start.sh
BIN_DIR='/home/paulo/Escritorio/SisProH'
TRUE=0
FALSE=0
#direccion del archivo Glog.sh
#Glog=$LIB_DIR/Glog.sh

Glog=$BIN_DIR/Glog.sh

#	sePuedeEjecutar()
#	{
#
#		if ! [ -f $Glog ]; then   #Si el archivo Glog no existe....
#		echo "No se puede ejecutar: primero se debe ejecutar IniPro.sh"
#		echo ""
#		exit 1
#		fi
#

#	}

# Funcion que devuelve TRUE si RecPro esta corriendo, FALSE en caso contrario

esta_corriendo() {

		x=`ps -e | grep '^.* RecPro\.sh$'`
		if [ $? -eq 0 ]; then
			echo "Error: RecPro ya se está ejecutando."
			pid=`ps -e | grep '^.* RecPro\.sh$' | sed 's/ \?\([0-9]*\).*/\1/'`
			./Glog.sh $nombreScript "El demonio ya se encuentra ejecutandose con PID: ${pid}"
			return $TRUE
		else
#$BIN_DIR/
			$BIN_DIR/RecPro.sh &

			x=`ps -e | grep '^.* RecPro\.sh$'`
			if [ $? -eq 0 ]; then
				pid=`ps -e | grep '^.* RecPro\.sh$' | sed 's/ \?\([0-9]*\).*/\1/'`
				./Glog.sh $nombreScript "Iniciando el demonio RecPro con el Process ID: ${pid}"
				return $FALSE
                        fi
                fi
		}
#sePuedeEjecutar
esta_corriendo