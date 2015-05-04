#!/bin/bash

#Shell script para detener procesos

nombreScript=`basename "$0"`
Glog=$BIN_DIR/Glog.sh
nombreComando= "RecPro.sh"

	sePuedeEjecutar()
	{

		if ! [ -f $Glog ]; then   #Si el archivo Glog no existe....
		echo "No se puede ejecutar: primero se debe ejecutar IniPro.sh"
		echo ""
		exit 1
		fi


	}
	
	function enviarLog(){
	$Glog "$nombreComando" "$2" "$3"
	}
	
	function stop(){
	x=`ps -e | grep '^.* RecPro\.sh$'`
	if [ $? -eq 0 ]; then
		echo "RecPro se está ejecutando. Lo vamos a cerrar."
		pid=`ps -e | grep '^.* RecPro\.sh$' | sed 's/ \?\([0-9]*\).*/\1/'`
		enviarLog $nombreComando  "El comando 'RecPro' fue terminado satisfactoriamente."
		kill ${pid}
	else
		echo "RecPro.sh no se estaba ejecutando."
		enviarLog $nombreComando  "El comando RecPro.sh no se estaba ejecutando."
	fi

}
sePuedeEjecutar
stop 