#!/bin/bash

#Shell script para detener procesos
function stop(){
RECPROPROCESSID=$(/bin/ps -fu $USER | grep "RecPro.sh" | grep -v "grep" | awk '{print $2}')
	if [ $? -eq 0 ]; then
		echo "RecPro se está ejecutando. Lo vamos a cerrar."
		kill $RECPROPROCESSID
		else
		echo "RecPro.sh no se estaba ejecutando."
		echo "El comando RecPro.sh no se estaba ejecutando."
		fi
}
stop
