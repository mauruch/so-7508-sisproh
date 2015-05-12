#Comando de instalacion

export GRUPO=$HOME/GRUPO06
export CONFDIR="$GRUPO/conf"

#Lo primero que vamos a hacer sería decirle a todos los scripts que son ejecutables
#De esta forma se los va a poder llamar de esta forma `./Mover.sh`
chmod +x InsPro.sh
chmod +x Glog.sh
chmod +x Mover.sh

function instalarDesdeCualquierLugar(){
if [ $PWD != $GRUPO ] && [ -d $GRUPO ]
then
	rm -r $GRUPO
fi

if [ ! -d $GRUPO ]
then
	`mkdir $GRUPO`
	arrayAMover=(`ls`)

	for f in ${arrayAMover[*]}; do
		if [ ! $f = 'InsPro.sh' ]
		then			
			mv "$f" "$GRUPO"
		fi
	done
	mv InsPro.sh $GRUPO
fi

#Te agrego esta línea para que el infpro no moleste con que le falta la carpeta de atrás como a la cucaracha
if [ ! -d $CONFDIR ]
then
	`mkdir $CONFDIR`
fi
}

######## Funcion setDir() para que el usuario ingrese los directorios ######
function setDir() {

#recupero los argumentos
keys=$1
values=$2
numElements=${#keys[@]}

if [ "$#" -ne 3 ]; then
	default=$keys
else
	default=$3
fi

for (( i=0;i<11;i++)); do

	eval k=\${$keys[i]}
	eval v=\${$values[i]}
	eval d=\${$default[i]}

	#se usa como 'default' lo que el usuario ingreso antes
	if [ "$#" -ne 3 ]; then
		eval d=\${"$k"}
	fi
	
	#ej Defina el directorio para los ejecutables (default):
	$GRUPO/Glog.sh "InsPro.sh" "Defina $v ($d):" "INFO"
    echo "Defina $v ($d):"
	read input

	#si presiona ENTER se seta el default
	if [ "$input" = "" ]; then
    	dir="$d"
	else
		if [ $k = "DATASIZE" ] || [ $k = "LOGSIZE" ]; then
			dir="$input"
		else
    		dir="$GRUPO/$input"
		fi
	fi
	

	eval $k=$dir
	eval val=\${"$k"}
	export $k

	#Checkeo si hay suficiente espacio
	if [ $k = "DATASIZE" ]; then
		finalSize=$(bash "$GRUPO/CheckSpaceDisk.sh")
		eval $k=$finalSize
		eval val=\${"$k"}
		#export DATASIZE con el nuevo valor
		export $k
	fi

	# se loguea la accion
#	sh Glog.sh "Se estableció $v: $k" "INFO"

done 
}



#######################################
#PRINCIPAL
instalarDesdeCualquierLugar

msgHeader="TP SO7508 Primer Cuatrimestre 2015. Tema H Copyright © Grupo 06"

bash $GRUPO/Glog.sh "InsPro.sh" "Inicio de Ejecución de InsPro"
bash $GRUPO/Glog.sh "InsPro.sh" "Directorio predefinido de Configuración: $CONFDIR"
bash $GRUPO/Glog.sh "InsPro.sh" "Log de la instalación: $CONFDIR/InsPro.sh.log" 


bash $GRUPO/Glog.sh "InsPro.sh" "Verificando si SisProH está instalado"

##Se checkea si esta instalado
insproConf="$CONFDIR/InsPro.conf"

bash $GRUPO/Glog.sh "InsPro.sh" "Verificando si existe el archivo $insproConf"

if [ ! -f $insproConf ]; then
	bash $GRUPO/Glog.sh "InsPro.sh" "El archivo no existe, se continúa con la instalción"
else 
	bash $GRUPO/Glog.sh "InsPro.sh" "El archivo existe, checkeando la instalación..."
	bash CheckSisProIns.sh
	exit 1
fi

################################

####### 5. Chequear que Perl esté instalado #########

bash $GRUPO/Glog.sh "InsPro.sh" "Verificando que Perl esté instalado"
if perl < /dev/null > /dev/null 2>&1  ; then
	#checkear version
	perlResult=`perl -v | grep 'perl 5'`
	if [ "$perlResult" != "" ]; then
		echo -e "$msgHeader \n"
		bash $GRUPO/Glog.sh "InsPro.sh" "Perl Version: `perl -v`"
		echo "Perl Version: `perl -v`"
		echo -e "\n"
	else
		bash $GRUPO/Glog.sh "InsPro" "Para instalar el TP es necesario contar con Perl 5 o superior. Efectúe su instalación e inténtelo 		nuevamente. \n Proceso de Instalación Cancelado" "ERROR"
		echo -e "Para instalar el TP es necesario contar con Perl 5 o superior. Efectúe su instalación e inténtelo nuevamente. \n Proceso de 			Instalación Cancelado"
		exit 1
	fi
else
	bash $GRUPO/Glog.sh "InsPro" "Para instalar el TP es necesario contar con Perl 5 o superior. Efectúe su instalación e inténtelo 			nuevamente. \n Proceso de Instalación Cancelado" "ERROR"
    echo -e "Para instalar el TP es necesario contar con Perl 5 o superior. Efectúe su instalación e inténtelo nuevamente. \n Proceso de 		Instalación Cancelado"
	exit 1
fi


 
array_key=( "BINDIR" "MAEDIR" "NOVEDIR" "DATASIZE" "ACEPDIR" "RECHDIR" "PROCDIR" "INFODIR" "DUPDIR" "LOGDIR" "LOGSIZE" )

array_value=( "el directorio para los ejecutables" "el directorio para los maestros y tablas" "el directorio de recepcion de documentos para la protocolizacion" "espacio mínimo libre para el arribo de estas novedades en Mbytes" "el directorio de grabación de las Novedades aceptadas" "el directorio de grabación de archivos rechazados" "el directorio de grabación de los documentos protocolizados" "el directorio de grabación de los informes de salida" "el nombre para el repositorio de archivos duplicados" "el directorio de logs" "el tamaño máximo para cada archivo de log en Kbytes" )

array_default=( "$GRUPO/bin" "$GRUPO/mae" "$GRUPO/novedades" "100" "$GRUPO/a_protocolizar" "$GRUPO/rechazados" "$GRUPO/protocolizados" "$GRUPO/informes" "$GRUPO/dup" "$GRUPO/log" "400" )

initInstallCondition=""

########6. a 17. Llamo a la funcion para que el usuario defina los directorios ########

numTimes=1
while [ "$initInstallCondition" != "s" ] 
do
	#si se llama por primera vez se usan los valores por default sino los que ya ingreso
	if [ $numTimes -eq 1 ]; then  
		setDir array_key array_value array_default
	else
		setDir array_key array_value
	fi
	
	#limpiar pantalla
	clear

	#llamo a la funcion para que imprima las variables
	#TODO: HACER OTRA FUNCION
	#bash $GRUPO/CheckSisProIns.sh "showVariables"

	echo "Estado de la instalación: LISTA"

	echo "Inicia la instalación? (s/n)"

	read initInstallCondition

	while [ "$initInstallCondition" != "s" ] && [ "$initInstallCondition" != "n" ] 
	do
		echo "Ingreso inválido... Inicia la instalación? (s/n)"
		read initInstallCondition
	done
	(( numTimes++ ))
	
	if [ "$initInstallCondition" != "s" ]; then
		#limpiar pantalla
		clear
	fi

done

######### 19. CONFIRMAR INICIO DE INSTALACIÓN #############

echo "Iniciando Instalación. Esta Ud. seguro? (s/n)"
read confirmInstall

echo -e "\n"

cd $GRUPO


######## 20. Instalación #################

if [ "$confirmInstall" = "s" ]; then
	echo "Creando Estructuras de directorio...."

	for (( i=0;i<11;i++)); do
		k="${array_key[$i]}"
		eval finalDir=\${"$k"}
		
		if [ "$k" != "DATASIZE" ] && [ "$k" != "LOGSIZE" ]; then
			#si no existe el dir se crea
			if [ ! -d $finalDir ]; then
    				mkdir $finalDir
				echo "$finalDir"
				
				if [ "$k" = "MAEDIR" ]; then
					mkdir "$finalDir/tab"
					echo "$finalDir/tab"
					mkdir "$finalDir/tab/ant"
					echo "$finalDir/tab/ant"
				fi
				if [ "$k" = "PROCDIR" ]; then
					mkdir "$finalDir/proc"
					echo "$finalDir/proc"
				fi
			fi
		fi
	done
fi

echo -e "\n"
echo -e "Instalando Archivos Maestros y Tablas \n"
bash $GRUPO/Glog.sh "InsPro.sh" "Instalando Archivos Maestros y Tablas"

#Nombre de la carpeta que contiene los datos
dataDir="2015-1C-Datos/"

###### 20.2 mueven los archivos maestros #######
lsMaeResult=`ls $dataDir | grep '\.mae$'`
	
for f in $lsMaeResult; do
	
	bash $GRUPO/Mover.sh "$dataDir$f" "$MAEDIR" "InsPro.sh"
done

###### 20.2  Se mueven los archivos tablas #######
lsTabResult=`ls $dataDir | grep '\.tab$'`

for f in $lsTabResult; do
	
  bash $GRUPO/Mover.sh "$dataDir$f" "$MAEDIR/tab" "InsPro.sh"
done

###### 20.3 Mover los ejecutables y funciones  #######
echo -e "Instalando Programas y Funciones \n"
bash $GRUPO/Glog.sh "InsPro.sh" "Instalando Programas y Funciones"
lsScriptsResult=`ls | grep '\.\(sh\|pl\)$'`
currentDirectory=`pwd`
for f in $lsScriptsResult; do
  if [ $f != "Glog.sh" ] && [ $f != "Mover.sh" ] && [ $f != "InsPro.sh" ] && [ $f != "CheckSisProIns.sh" ] && [ $f != "CheckSpaceDisk.sh" ]; then  
    	bash $GRUPO/Mover.sh "$currentDirectory/$f" "$BINDIR" "InsPro.sh"
  fi
done

###### 20.4 Actualizar el archivo de configuración  #######
echo -e "Actualizando la configuración del sistema \n"
bash $GRUPO/Glog.sh "InsPro.sh" "Actualizando la configuración del sistema"
if [ ! -f $insproConf ]; then
	touch $insproConf
fi
for (( i=0;i<11;i++)); do
	k="${array_key[$i]}"
	eval finalDir=\${"$k"}
	chmod +w $insproConf
	echo "$k=$finalDir" >> $insproConf
	
	
done

###### FIN ###########
echo "Instalación CONCLUIDA"

#instalacion exitosa
