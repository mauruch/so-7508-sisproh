#Comando para la Protocolización

nombreScript=`basename "$0"`
$GRUPO/Glog.sh "$nombreScript" "Inicio de ProPro" "INFO"

cd $ACEPDIR
contador=0
if [ -d Peron1 ]; then
	ARRAY[$contador]="Peron1"
	contador=$((contador+1))
fi
if [ -d Peron2 ]; then
	ARRAY[$contador]="Peron2"
	contador=$((contador+1))
fi
if [ -d Lonardi ]; then
	ARRAY[$contador]="Lonardi"
	contador=$((contador+1))
fi
if [ -d Aramburu ]; then
	ARRAY[$contador]="Aramburu"
	contador=$((contador+1))
fi
if [ -d Guido ]; then
	ARRAY[$contador]="Guido"
	contador=$((contador+1))
fi
if [ -d Illia ]; then
	ARRAY[$contador]="Illia"
	contador=$((contador+1))
fi
if [ -d Lanusse ]; then
	ARRAY[$contador]="Lanusse"
	contador=$((contador+1))
fi
if [ -d Campora ]; then
	ARRAY[$contador]="Campora"
	contador=$((contador+1))
fi
if [ -d Lastiri ]; then
	ARRAY[$contador]="Lastiri"
	contador=$((contador+1))
fi
if [ -d Peron3 ]; then
	ARRAY[$contador]="Peron3"
	contador=$((contador+1))
fi
if [ -d Martinez ]; then
	ARRAY[$contador]="Martinez"
	contador=$((contador+1))
fi
if [ -d Videla ]; then
	ARRAY[$contador]="Videla"
	contador=$((contador+1))
fi
if [ -d Viola ]; then
	ARRAY[$contador]="Viola"
	contador=$((contador+1))
fi
if [ -d Galtieri ]; then
	ARRAY[$contador]="Galtieri"
	contador=$((contador+1))
fi
if [ -d Bignone ]; then
	ARRAY[$contador]="Bignone"
	contador=$((contador+1))
fi
if [ -d Alfonsin ]; then
	ARRAY[$contador]="Alfonsin"
	contador=$((contador+1))
fi
if [ -d Menem1 ]; then
	ARRAY[$contador]="Menem1"
	contador=$((contador+1))
fi
if [ -d Menem2 ]; then
	ARRAY[$contador]="Menem2"
	contador=$((contador+1))
fi
if [ -d Rua ]; then
	ARRAY[$contador]="Rua"
	contador=$((contador+1))
fi
if [ -d Puerta ]; then
	ARRAY[$contador]="Puerta"
	contador=$((contador+1))
fi
if [ -d Saa ]; then
	ARRAY[$contador]="Saa"
	contador=$((contador+1))
fi
if [ -d Caamaño ]; then
	ARRAY[$contador]="Caamaño"
	contador=$((contador+1))
fi
if [ -d Duhalde ]; then
	ARRAY[$contador]="Duhalde"
	contador=$((contador+1))
fi
if [ -d Kirchner ]; then
	ARRAY[$contador]="Kirchner"
	contador=$((contador+1))
fi
if [ -d Fernandez ]; then
	ARRAY[$contador]="Fernandez"
	contador=$((contador+1))
fi
if [ -d Fernandez2 ]; then
	ARRAY[$contador]="Fernandez2"
	contador=$((contador+1))
fi

contadorAceptados=0
contadorRechazados=0



GrabarRegistroProtocolizado(){
#$1 linea
#$2 cod gestion
#$3 nombre del archivo
cd $PROCDIR
#si no existe el directorio, lo crea
if [ ! -d "$2" ]; then
  mkdir "$2"
fi
cd "$2"
codNorma="$(echo "$3" | cut -d '_' -f 2)"
anio="$(echo "$1" | cut -d ';' -f 1 | cut -d '/' -f 3)"
archivo="$anio"".""$codNorma"
if [ ! -e "$archivo" ]; then
touch $archivo
fi
contadorAux=1
for var in {0..8} 
do
	REGISTRO[$var]="$(echo "$1" | cut -d ';' -f "$contadorAux")"
	contadorAux=$((contadorAux+1))
done
echo "$3"";""${REGISTRO[0]}"";""${REGISTRO[1]}"";""$anio"";""${REGISTRO[2]}"";""${REGISTRO[3]}"";""${REGISTRO[4]}"";""${REGISTRO[5]}"";""${REGISTRO[6]}"";""${REGISTRO[7]}"";""${REGISTRO[8]}" >> $archivo

}

GrabarRegistroRechazado(){
#$2 linea
#$1 es el codigo de gestion
#$3 nombre del archivo de input
#$4 motivo del rechazo

cd $PROCDIR
archivo=$1".rech"
if [ ! -e "$archivo" ]; then
touch $archivo
fi

echo "$3"";""$4"";""$2" >> $archivo

}

AgregarContadorALaTabla(){
#$1 es la regex
#si es la primera vez que se actualiza, mueve al archivo
$GRUPO/Glog.sh "$nombreScript" "Se agrego un contador a la tabla de contadores" "INFO"
if [ -e $MAEDIR/tab/axg.tab ]; then
	cd $MAEDIR/tab
	if [ ! -d "ant" ]; then
  		mkdir "ant"
	fi	
	$GRUPO/Glog.sh "$nombreScript" “tabla de contadores preservada antes de su modificación en $MAEDIR/tab/ant” "INFO"
	$GRUPO/Mover.sh $MAEDIR/tab/axg.tab $MAEDIR/tab/ant ProPro.sh
fi
cd $MAEDIR/tab
ultimoId="$(tail -1 axgAux | cut -d ';' -f 1)"
ultimoId=$((ultimoId+1))
fechaActual="$(date +"%d/%m/%Y")"
echo "$ultimoId"";""$1""2;""$USER"";""$fechaActual" >> axgAux
}


ActualizarContadorDeLaTabla(){
#$1 es la norma
#$2 es la regex
#si es la primera vez que se actualiza, mueve al archivo
$GRUPO/Glog.sh "$nombreScript" "Se actualizo un contador de la tabla de contadores" "INFO"
if [ -e $MAEDIR/tab/axg.tab ]; then
	cd $MAEDIR/tab
	if [ ! -d "ant" ]; then
  		mkdir "ant"
	fi	
	$GRUPO/Glog.sh "$nombreScript" “tabla de contadores preservada antes de su modificación en $MAEDIR/tab/ant” "INFO"
	$GRUPO/Mover.sh $MAEDIR/tab/axg.tab $MAEDIR/tab/ant ProPro.sh
fi
cd $MAEDIR/tab
normaActual="$1"
normaActualizada=$((normaActual+1))
fechaVieja="$(grep "$2" axgAux | cut -d ";" -f 8)"
diaViejo="$(echo "$fechaVieja" | cut -d '/' -f 1)"
mesViejo="$(echo "$fechaVieja" | cut -d '/' -f 2)"
anioViejo="$(echo "$fechaVieja" | cut -d '/' -f 3)"
usuarioAnterior="$(grep "$2" axgAux | cut -d ";" -f 7)"
fechaActual="$(date +"%d/%m/%Y")"
diaActual="$(echo "$fechaActual" | cut -d '/' -f 1)"
mesActual="$(echo "$fechaActual" | cut -d '/' -f 2)"
anioActual="$(echo "$fechaActual" | cut -d '/' -f 3)"
#necesito asignarle el auxiliar, a otro, dado que no se puede hacer axgAux > axgAux
cat axgAux > axgAux2
sed /"$2"/s/"$1"";""$usuarioAnterior"";"$diaViejo"\/"$mesViejo"\/"$anioViejo/"$normaActualizada"";""$USER"";"$diaActual"\/"$mesActual"\/"$anioActual/g axgAux2 > axgAux

}

ProtocolizarCorrientes(){
#$1 es la linea
#$2 es el nombre del archivo
#$3 es el codigo de gestion
anioEnCurso=2015
codigoGestion="$(echo "$2" | cut -d '_' -f 1)"
codigoEmisor="$(echo "$2" | cut -d '_' -f 3)"
codigoNorma="$(echo "$2" | cut -d '_' -f 2)"
regex="$codigoGestion"";""$anioEnCurso"";""$codigoEmisor"";""$codigoNorma"";"
if [ -e $MAEDIR/tab/axg.tab ]; then
	cat $MAEDIR/tab/axg.tab > $MAEDIR/tab/axgAux
fi
cd $MAEDIR/tab
norma="$(grep "$regex" axgAux | cut -d ";" -f 6)"
if [ -z "$norma" ]; then
	norma=1
	registro="$( echo "$1" | sed s/";;"/";"$norma";"/g)"
	GrabarRegistroProtocolizado "$registro" "$3" "$2"
	AgregarContadorALaTabla "$regex"
else
	registro="$( echo "$1" | sed s/";;"/";"$norma";"/g)"
	GrabarRegistroProtocolizado "$registro" "$3" "$2"
	ActualizarContadorDeLaTabla $norma "$regex"
fi

}

ValidarCorrientes(){
#$1 es el nombre del archivo
#$2 es la linea, el registro
#Devuelve 1 si paso, 0 si no
pasoValidacion=0
emisor="$(echo "$1" | cut -d '_' -f 3)"
firma="$( grep "$emisor"";" "$MAEDIR/emisores.mae" | cut -d ';' -f 3 )"
firmaDelRegistro="$(echo "$2" | cut -d ';' -f 8)"
if [ "$firma" = "$firmaDelRegistro" ]; then
	pasoValidacion=1
fi

return $pasoValidacion
}

ValidarNormaHistoricos(){
#$1 es la linea
#Devuelve 1 si paso la validacion, 0 si no
pasoValidacion=0
norma="$(echo "$1" | cut -d ';' -f 2)"
if [ $norma -gt 0 ]; then
	pasoValidacion=1
fi
return $pasoValidacion
}

ValidarFechaNormaEnRangoDeGestion(){
#$1 es la linea
#$2 es el codigo de gestion
#Devuelve 1 si paso la validacion, 0 si no
pasoValidacion=0
fecha="$(echo "$1" | cut -d ';' -f 1)"
dia="$(echo "$fecha" | cut -d '/' -f 1)"
mes="$(echo "$fecha" | cut -d '/' -f 2)"
anio="$(echo "$fecha" | cut -d '/' -f 3)"
fechaComoNumero="$anio""$mes""$dia"
registroDeGestiones=$(grep "$2"";" $MAEDIR/gestiones.mae)
fechaDesde="$(echo "$registroDeGestiones" | cut -d ';' -f 2)"
diaD="$(echo "$fechaDesde" | cut -d '/' -f 1)"
mesD="$(echo "$fechaDesde" | cut -d '/' -f 2)"
anioD="$(echo "$fechaDesde" | cut -d '/' -f 3)"
fechaDesdeComoNumero="$anioD""$mesD""$diaD"
if [ $fechaComoNumero -ge $fechaDesdeComoNumero ]; then
	autoNumera="$(echo "$registroDeGestiones" | cut -d ';' -f 5)"
	if [ $autoNumera -ne 1 ]; then
		fechaHasta="$(echo "$registroDeGestiones" | cut -d ';' -f 3)"
		diaH="$(echo "$fechaHasta" | cut -d '/' -f 1)"
		mesH="$(echo "$fechaHasta" | cut -d '/' -f 2)"
		anioH="$(echo "$fechaHasta" | cut -d '/' -f 3)"
		fechaHastaComoNumero="$anioH""$mesH""$diaH"		
		if [ $fechaComoNumero -lt $fechaHastaComoNumero ]; then
			pasoValidacion=1
		fi
	else
		pasoValidacion=1
	fi

fi

return $pasoValidacion

}

ValidarFechaNorma(){
# $1 es la linea
#0 es false, 1 es true
pasoValidacion=0
fecha="$(echo "$1" | cut -d ';' -f 1)"
dia="$(echo "$fecha" | cut -d '/' -f 1)"
mes="$(echo "$fecha" | cut -d '/' -f 2)"
anio="$(echo "$fecha" | cut -d '/' -f 3)"
fechaActual="$(echo `date +%F`)"
diaActual="$(echo "$fechaActual" | cut -d '-' -f 3)"
mesActual="$(echo "$fechaActual" | cut -d '-' -f 2)"
AnioActual="$(echo "$fechaActual" | cut -d '-' -f 1)"
if [ $dia -lt 32 ] && [ $mes -lt 13 ] && [ $anio -le $AnioActual ]; then

	pasoValidacion=1

fi

return $pasoValidacion

}

ValidarRegistros(){
#$1 nombre del archivo
#$2 cod de gestion
#si paso todas las validaciones, es 1, sino 0
pasoTodasLasValidaciones=1
while read linea
do
	pasoTodasLasValidaciones=1
	ValidarFechaNorma "$linea"
	pasoValidacionFecha=$?
  	if [ $pasoValidacionFecha -eq 1 ]; then
		ValidarFechaNormaEnRangoDeGestion "$linea" $2
		pasoValidacionRangoDeFecha=$?
		if [ $pasoValidacionRangoDeFecha -eq 1 ]; then
			registroDeGestiones=$(grep "$2"";" $MAEDIR/gestiones.mae)
			autoNumera="$(echo "$registroDeGestiones" | cut -d ';' -f 5)"
			#si autoNumera es 1, entonces es un registro corriente, sino es historico			
			if [ $autoNumera -eq 0 ]; then
				ValidarNormaHistoricos "$linea"
				pasoHistoricos=$?
				if [ $pasoHistoricos -ne 1 ]; then
					GrabarRegistroRechazado $2 "$linea" $1 "numero de norma invalido"
					pasoTodasLasValidaciones=0
				fi			
			else				
				ValidarCorrientes $1 "$linea"
				pasoCorrientes=$?
				if [ $pasoCorrientes -eq 0 ]; then
					
					GrabarRegistroRechazado $2 "$linea" $1 "codigo de firma invalido"
					pasoTodasLasValidaciones=0
				fi	
			fi
			
		else			
			GrabarRegistroRechazado $2 "$linea" $1 "fecha fuera del rango de la gestion"
			pasoTodasLasValidaciones=0
		fi
	else
	
	GrabarRegistroRechazado $2 "$linea" $1 "fecha invalida"
	pasoTodasLasValidaciones=0
	
	fi
	if [ $pasoTodasLasValidaciones -eq 1 ]; then
	
		if [ $autoNumera -eq 0 ]; then
			
			GrabarRegistroProtocolizado "$linea" "$2" "$1"
		else
			ProtocolizarCorrientes "$linea" "$1" "$2"
		fi
	
	fi
done < $ACEPDIR/"$2"/"$1"
}


ValidarNormaEmisor(){
norma="$(echo "$1" | cut -d '_' -f 2)"
emisor="$(echo "$1" | cut -d '_' -f 3)"
aux=($(grep "$norma"";""$emisor" $MAEDIR/tab/nxe.tab))
if [ "${#aux[@]}" != 0 ]; then
	ValidarRegistros $1 $2
	# grabar log 
	contadorAceptados=$((contadorAceptados+1))
	$GRUPO/Mover.sh $ACEPDIR/"$2"/"$1" $PROCDIR/proc ProPro.sh
else
	$GRUPO/Glog.sh "$nombreScript" "Se rechaza el archivo. Emisor no habilitado en este tipo de norma." "ERR"
	contadorRechazados=$((contadorRechazados+1))
	$GRUPO/Mover.sh $ACEPDIR/"$2"/"$1" $RECHDIR ProPro.sh
fi

}


ProcesarArchivo(){
cd $PROCDIR/proc
$GRUPO/Glog.sh "$nombreScript" "Archivo a procesar: $1" "INFO"
if [ -s $1 ]; then
	$GRUPO/Glog.sh "$nombreScript" "Se rechaza el archivo por estar DUPLICADO." "ERR"
	contadorRechazados=$((contadorRechazados+1))
	$GRUPO/Mover.sh $ACEPDIR/"$2"/"$1" $RECHDIR ProPro.sh
else
	ValidarNormaEmisor $1 $2
fi

}

for i in "${ARRAY[@]}"
do
cd $ACEPDIR/$i

	variable2=($(ls | sort -t '-' -k 3 -k 2 -k 1))
	for j in "${variable2[@]}"
	do
		ProcesarArchivo $j $i
	done	
done

cd $MAEDIR/tab
if [ -e axgAux ]; then
	mv axgAux axg.tab
fi

if [ -e axgAux2 ]; then
	rm axgAux2
fi
#los tres logs de los contadores
#log de fin de propro

$GRUPO/Glog.sh "$nombreScript" "Cantidad de archivos a procesar" "INFO"
$GRUPO/Glog.sh "$nombreScript" "Cantidad de archivos procesados $contadorAceptados" "INFO"
$GRUPO/Glog.sh "$nombreScript" "Cantidad dearchivos rechazados $contadorRechazados" "INFO"
$GRUPO/Glog.sh "$nombreScript" "Fin de ProPro" "INFO"
