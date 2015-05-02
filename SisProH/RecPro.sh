#!/bin/bash

#Comando para la Recepción de documentos para protocolización


### Variables ###
## NOTA: HAY QUE AJUSTAR LAS CARPETAS

carpetaNovedades="NOVEDIR"
carpetaAceptados="ACEPDIR"
carpetaRechazados="RECHDIR"

nombreScript=`basename "$0"`

### fin variables ###


### funciones ###


# Función que sirve para aceptar un archivo
# $1 es la ruta del archivo
function aceptarArch {
	echo $1
	codGestion=${1%%_*} 
	mkdir -p "$carpetaAceptados/$codGestion"
	./Mover.sh "$carpetaNovedades/$1" "$carpetaAceptados/$codGestion"
	echo "script" $nombreScript
	./Glog.sh $nombreScript "El archivo $1 ha sido aceptado y movido a la carpeta $carpetaAceptados/$codGestion"

}


# Función que sirve para rechazar un archivo
# $1 es la ruta del archivo
function rechazarArch {
	./Mover.sh "$carpetaNovedades/$1" "$carpetaRechazados"

}


# Función a la que se elvía el nombre de un archivo junto con su extensión
# Retorna 0 en caso de ser una extensión inválida, 1 en caso contrario
function valExtensionArch(){

	#extension=$(echo $arch | rev | cut -d'.' -f1 | rev)
        #echo "Extension: "$extension" ("$arch")"
	#if [ "$extension" == "txt" ]
	#then
	#	return 1
	#else
	#	return 0
	#
	#fi

	archivo=`find NOVEDIR/ -name $1 -type f -exec grep -Il . {} \; | wc -l`
	echo $archivo

	if [ $archivo -ge 1 ]
	then
		return 1

	else
		return 0
	fi


}

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

	sleep 60


fi
