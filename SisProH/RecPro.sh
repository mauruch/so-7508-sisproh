#!/bin/bash

#Comando para la Recepción de documentos para protocolización


### Variables ###

carpetaNovedades=$NOVEDIR
carpetaAceptados=$ACEPDIR
carpetaRechazados=$RECHDIR
carpetaMaestros=$MAEDIR
numeroDeArchivosAceptados=0


DORMIR_RECPRO=60

nombreScript=`basename "$0"`
ciclo=0

### fin variables ###


### funciones ###


# Función que sirve para aceptar un archivo
# $1 es la ruta del archivo
function aceptarArch {
	codGestion=${1%%_*} 
	mkdir -p "$carpetaAceptados/$codGestion"
	$GRUPO/Mover.sh "$carpetaNovedades/$1" "$carpetaAceptados/$codGestion"
	$GRUPO/Glog.sh $nombreScript "El archivo $1 ha sido aceptado y movido a la carpeta $carpetaAceptados/$codGestion"
	numeroDeArchivosAceptados=$((numeroDeArchivosAceptados+1))

}


# Función que sirve para rechazar un archivo
# $1 es la ruta del archivo
function rechazarArch {
	$GRUPO/Mover.sh "$carpetaNovedades/$1" "$carpetaRechazados"
	

}


# Función a la que se elvía el nombre de un archivo junto con su extensión
# Retorna 0 en caso de ser una extensión inválida, 1 en caso contrario
function valExtensionArch(){

	archivo=`find $NOVEDIR/ -name $1 -type f -exec grep -Il . {} \; | wc -l`
	
	if [ $archivo -ge 1 ]
	then
		return 1

	else
		return 0
	fi
}


#Función a la que se le envía un string y valida que sea una fecha
#Retorna 1 en caso de éxito, 0 en caso contrario
function valFecha(){
diasMeses=(31 29 31 30 31 30 31 31 30 31 30 31)

	nombreValido=`echo $1 | grep '^[0-3][0-9][/,-][0-1][0-9][/,-][0-9][0-9][0-9][0-9]$' | wc -l`
		
	if [ $nombreValido -eq 1 ]
	then
		dia=${1:0:2}
		mes=${1:3:2}
		if [ $mes -le 12 ]
		then
			let mes=$mes-1
			var=${diasMeses[$mes]}
			if [ $dia-gt$var ]
			then	
				return 1
				
			fi
		else
			return 0
		fi
	else
		return 0
	fi

	return 0

}


# Valida <cod_gestion>_<cod_norma>_<cod_emisor>_<Nro_archivo>_<fecha>	
  ##Fecha tiene formato YYYY-MM-DD
function valFormatoNombreArch(){
	nombre=$1
	mensajeError=( "Gestión Inexistente" "Norma Inexistente" "Emisor Inexistente" "-" "Fecha Fuera de Rango" "Fecha Inválida" )

	formatoNombre='^[A-Z,a-z,0-9]*_[A-Z]*_[0-9]*_[0-9]*_[0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]$'
	nombreValido=`echo "$nombre" | grep "$formatoNombre" | wc -l`
	
	if [ $nombreValido -eq 1 ]
	then
		cont=1
		while [ $cont -lt 6 ] && [ $nombreValido -ne 0 ]
		do
			validar=${nombre%%_*} 
			
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
			valFecha $validar

			if [ $? -eq 1 ]
			then
				#validar=$(date -d "$validar" +'%Y%d%m')
				dia=${validar:0:2}
				mes=${validar:3:2}
				anyo=${validar:6:4}
				validar=$anyo$mes$dia

			
				desde=`grep $codGestion';' $carpetaMaestros/gestiones.mae | cut -d';' -f2 --output-delimiter=$'\n'`
				hasta=`grep $codGestion';' $carpetaMaestros/gestiones.mae | cut -d';' -f3 --output-delimiter=$'\n'`
			
				valFecha $desde
				if [ $? -eq 1 ]
				then
					#desde=$(date -d "$desde" +'%Y%d%m'); 
					dia=${desde:0:2}
					mes=${desde:3:2}
					anyo=${desde:6:4}
					desde=$anyo$mes$dia

					if [ -z $hasta ] || [ $hasta == 'NULL' ]
					then
						hasta=$(date +'%d/%m/%Y'); 
						
					fi
					
					valFecha $hasta
					if [ $? -eq 1 ]
					then	
						#hasta=$(date -d "$hasta" +'%Y%d%m'); 
						dia=${hasta:0:2}
						mes=${hasta:3:2}
						anyo=${hasta:6:4}
						hasta=$anyo$mes$dia
												
						if [ $validar -gt $hasta ] || [ $validar -lt $desde ]
						then
							nombreValido=0
						fi

					else 
						nombreValido=0
						let cont=$cont+1
					fi

				else
					nombreValido=0
					let cont=$cont+1

				fi
			else
				nombreValido=0
				let cont=$cont+1
			fi
		 	;;
	  		esac

			if [ $cont -eq 1 ] || [ $cont -eq 2 ] || [ $cont -eq 3 ]
			then
				nombreValido=`cut -d';' -f1 $carpetaMaestros/$archivo | grep $validar$ | wc -l`
				
			fi

			nombre=${nombre#*_}
			let cont=$cont+1
		done

		if [ $nombreValido -eq 0 ]
		then
			let cont=$cont-2
			mensaje="Nombre inválido, "${mensajeError[$cont]}
			$GRUPO/Glog.sh $nombreScript "El archivo $1 ha sido rechazado por: $mensaje"
			return 0
		else
			return 1
		fi
		
	else
		mensaje="Campo inválido"
		$GRUPO/Glog.sh $nombreScript "El archivo $1 ha sido rechazado por: $mensaje"
		return 0
	fi

}



### fin funciones ###

# Inicio de la ejecución del script
function detectarArribos(){

	# Inicio de la ejecución del script
	if [ $# -gt 1 ]
	then
		echo "No se necesitan parametros para la ejecucion de RecPro, los mismos han sido ignorados"
	fi

	#PASO 1: Imprimo el log
	$GRUPO/Glog.sh "$nombreScript" "ciclo nro... $1"

	#PASO 2: Chequeo si hay archivos en NOVEDIR
	cantidadArchivos=`ls -1 "$carpetaNovedades" | wc -l`

	if [ $cantidadArchivos -ge 1 ]
	then
		# Procesar archivos.
		for arch in `ls "$carpetaNovedades"`
		do
			valExtensionArch $arch
			validacion=$?
			if [ $validacion -eq 1 ]
			then
		
				#chequeo que el archivo no esté vacío
				if [ -s $carpetaNovedades/$arch ]
				then
					valFormatoNombreArch $arch
					validacion=$?
					if [ $validacion -eq 1 ]
					then
						#ACEPTADO
						aceptarArch $arch 
					else
						#ACEPTADO
						rechazarArch $arch 
				
					fi
				else
					#RECHAZADO
					$GRUPO/Glog.sh  $nombreScript "El archivo $arch ha sido rechazado por: Archivo vacío"
					rechazarArch $arch 
				fi

			else
				#RECHAZADO
				$GRUPO/Glog.sh  $nombreScript "El archivo $arch ha sido rechazado por: Tipo Inválido"
				rechazarArch $arch 

			fi

		done

	else
	    	#si no hay archivos ir al paso NOVEDADES PENDIENTES"
		res=`ps -A | grep 'ProPro.sh' | wc -l`
		if [ $res -gt 0 ]
		then
			pid=`pgrep feprima.sh`
			$GRUPO/Glog.sh  $nombreScript "ProPro ya corriendo bajo el no.: $pid"
		else
			export numeroDeArchivosAceptados
			$BINDIR/ProPro.sh &
			numeroDeArchivosAceptados=0
			if [ $? -eq 0 ]
			then
				$GRUPO/Glog.sh  $nombreScript "ProPro corriendo bajo el no.: $!"
			else
				$GRUPO/Glog.sh  $nombreScript "ProPro no se pudo inicializar"
			fi
		fi

	fi
}

res=`ps -A | grep 'RecPro.sh' | wc -l`
#res cuenta una línea más a la cantidad de procesos
if [ $res -gt 1 ]
then
	while :;do
		let ciclo=$ciclo+1
		detectarArribos $ciclo
		sleep $DORMIR_RECPRO
	
	done
fi
