#Shell script para disparar procesos

#!/bin/bash

# Descripcion: Comando que inicia la ejecucion del demonio 'RecPro'.
#. ../conf/InsPro.conf

#$LIB_DIR definir en archivo de configuracion


TRUE=1
FALSE=0
Glog=$LIB_DIR/Glog.sh
nombreComando=RecPro
# Funcion que devuelve TRUE si RecPro esta corriendo, FALSE en caso contrario.
sePuedeEjecutar()
{
	#if ! [ -f $Glog ]; then
	echo "No se puede ejecutar: primero se debe ejecutar RecPro.sh"
	#echo ""
	#exit 1
	#fi

}


esta_corriendo()
{	

		x=`ps -e | grep '^.* RecPro\.sh$'`
		if [ $? -eq 0 ]; then
			echo "Error: RecPro ya se está ejecutando."
			pid=`ps -e | grep '^.* RecPro\.sh$' | sed 's/ \?\([0-9]*\).*/\1/'`	
			$Glog $nombreComando E "El demonio ya se encuentra ejecutandose con PID: ${pid}"
			return $TRUE
		else

			$BIN_DIR/RecPro.sh &

			x=`ps -e | grep '^.* RecPro\.sh$'`
			if [ $? -eq 0 ]; then
				pid=`ps -e | grep '^.* RecPro\.sh$' | sed 's/ \?\([0-9]*\).*/\1/'`
				$Glog $nombreComando I "Iniciando el demonio RecPro con el Process ID: ${pid}"		
				return $FALSE
			fi	
		fi
}

sePuedeEjecutar
esta_corriendo


###############################Dani fijate esto#############################################

# Valida <cod_gestion>_<cod_norma>_<cod_emisor>_<Nro_archivo>_<fecha>	
  
function valFormatoNombreArch(){
	nombre=$1
	mensajeError=( "Gestión Inexistente" "Norma Inexistente" "Emisor Inexistente" "-" "Fecha Fuera de Rango" )

	#nombre=${1%%\\n}
	#echo $nombre

	formatoNombre='^[A-Z,a-z,0-9]*_[A-Z]*_[0-9]*_[0-9]*_[0-3][0-9]-[0-1][0-9]-[0-9][0-9][0-9][0-9]$'
	nombreValido=`echo "$nombre" | grep "$formatoNombre" | wc -l`
	echo "prueba: "$nombreValido

	if [ $nombreValido -eq 1 ]
	then
		cont=1
		while [ $cont -lt 6 ] && [ $nombreValido -ne 0 ]
		do
			validar=${nombre%%_*} 
			echo $validar

			case $cont in
	     		1)
			# "<cod_gestion>"
			archivo='gestiones.mae'
			codGestion=$validar
	     		;;
	     		2)
			# "<cod_norma>"
			archivo='normas.mae'
	     		;;
			3)
			# "<cod_emisor>"
			archivo='emisores.mae'
	     		;;
			5)
			# "<fecha>"
			# La fecha se valida según el rango de la gestión, 
			# en el caso de ser la gestión actual, se toma la fecha de hoy
			
			validar=${validar//-//}
			validar=$(date -d "$validar" +'%Y%d%m')
			echo "a validar" $validar

			desde=`grep $codGestion';' MAEDIR/gestiones.mae | cut -d';' -f2 --output-delimiter=$'\n'`
			hasta=`grep $codGestion';' MAEDIR/gestiones.mae | cut -d';' -f3 --output-delimiter=$'\n'`
			
			echo "desde" $desde
			desde=$(date -d "$desde" +'%Y%d%m'); 
			echo $desde

			echo "hasta" $hasta
			if [ $hasta == 'NULL' ] 
			then
				hasta=$(date +'%Y%m%d')
			else
				hasta=$(date -d  "$hasta" +'%Y%d%m'); 
			fi
			
			echo $hasta

			if [ $validar -gt $hasta ] || [ $validar -lt $desde ]
			then
				nombreValido=0
			fi
		 	;;
	  		esac

			if [ $cont -eq 1 ] || [ $cont -eq 2 ] || [ $cont -eq 3 ]
			then
				resultadoValidacion=`cut -d';' -f1 MAEDIR/$archivo | grep $validar | wc -l`
				echo `cut -d';' -f1 MAEDIR/$archivo | grep $validar `
				echo "resultado validacion: " $resultadoValidacion
			fi

			nombre=${nombre#*_}
			echo $nombre
			let cont=$cont+1
		done

		if [ $nombreValido -eq 0 ]
		then
			let cont=$cont-2
			mensaje="Nombre inválido, "${mensajeError[$cont]}
			./Glog.sh $nombreScript "El archivo $1 ha sido rechazado por: $mensaje"
			return 0
		else
			return 1
		fi
		
	else
		mensaje="Cantidad de campos inválido"
		./Glog.sh $nombreScript "El archivo $1 ha sido rechazado por: $mensaje"
		return 0
	fi

}



### fin funciones ###

function detectarArribos(){

	# Inicio de la ejecución del script

	if [ $# -gt 1 ]
	then
		echo "No se necesitan parametros para la ejecucion de RecPro, los mismos han sido ignorados"
	fi

	 echo "$nombreScript"
	#PASO 1: Imprimo el log
	./Glog.sh "$nombreScript" "ciclo nro..."

	#PASO 2: Chequeo si hay archivos en NOVEDIR
	cantidadArchivos=`ls -1 "$carpetaNovedades" | wc -l`

	echo $cantidadArchivos

	if [ $cantidadArchivos -ge 1 ]
	then
		# Procesar archivos.
		for arch in `ls "$carpetaNovedades"`
		do
			echo 'procesando' $arch
			valExtensionArch $arch
			validacion=$?
			echo $validacion
			if [ $validacion -eq 1 ]
			then
		
				#chequeo que el archivo no esté vacío
				if [ -s $arch ]
				then
					valFormatoNombreArch $arch
					validacion=$?
					echo $validacion
					if [ $validacion -eq 1 ]
					then
						echo "todo bien"
						aceptarArch $arch 
					else
						echo "mover a rechazados"
						rechazarArch $arch 
				
					fi
				else
					echo "mover a rechazados"
					./Glog.sh  $nombreScript "El archivo $arch ha sido rechazado por: Archivo vacío"
					rechazarArch $arch 
				fi

			else
				echo "mover a rechazados"
				./Glog.sh  $nombreScript "El archivo $arch ha sido rechazado por: Tipo Inválido"
				rechazarArch $arch 

			fi

		done

	else
	    	echo "si no hay archivos ir al paso NOVEDADES PENDIENTES"
		res=`ps -C "ProPro.sh" | wc -l `
		#res cuenta una línea más a la cantidad de procesos
		if [ $res -gt 1 ]
		then
			pid=`pgrep feprima.sh`
			echo "ProPro ya corriendo bajo el no.: $pid"
			./Glog.sh  $nombreScript "ProPro ya corriendo bajo el no.: $pid"
		else
			./ProPro.sh &
			echo "ProPro corriendo bajo el no.: $!"
			./Glog.sh  $nombreScript "ProPro corriendo bajo el no.: $!"
		fi

		#sleep 60


	fi
}

# Esto lo que hace es ejecturar la funcion encapsulada
while :;do
	detectarArribos
sleep 20
done