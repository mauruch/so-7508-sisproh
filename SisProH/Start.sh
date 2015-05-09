nombreScript=`basename "$0"`

function sePuedeEjecutar(){
		if [ "$BINDIR" = '' ]; then   #Si no tengo BINDIR como una variable puesta por el inipro
		echo "Ambiente no inicializado, por favor corra ". IniPro.sh" en la terminal"		
		exit 1
		fi
	}

function esta_corriendo(){

		x=`ps -e | grep '^.* RecPro\.sh$'`
		if [ $? -eq 0 ]; then
			pid=`ps -e | grep '^.* RecPro\.sh$' | sed 's/ \?\([0-9]*\).*/\1/'`
			echo "Error: RecPro ya se está ejecutando con PID: ${pid}"
			$GRUPO/Glog.sh "$nombreScript" "El demonio ya se encuentra ejecutandose con PID: ${pid}"
			exit 0
		else
			$BINDIR/RecPro.sh &	#Ejecuto RecPro.sh

			x=`ps -e | grep '^.* RecPro\.sh$'`
			if [ $? -eq 0 ]; then
				pid=`ps -e | grep '^.* RecPro\.sh$' | sed 's/ \?\([0-9]*\).*/\1/'`
				echo "RecPro.sh inicializado con PID: ${pid}"				
				$GRUPO/Glog.sh "$nombreScript" "Iniciando el demonio RecPro con el Process ID: ${pid}"
				exit 0
			fi
		fi
}

sePuedeEjecutar
esta_corriendo