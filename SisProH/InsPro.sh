#Comando de instalacion

export insproLog="InsPro.log"
export GRUPO=$HOME/Sisop2015/so-7508-sisproh/Instalacion
export CONFDIR="$GRUPO/conf"

#Lo primero que vamos a hacer sería decirle a todos los scripts que son ejecutables
#De esta forma se los va a poder llamar de esta forma `./Mover.sh`
chmod +x InsPro.sh
chmod +x Glog.sh
chmod +x InfPro.pl
chmod +x IniPro.sh
chmod +x Mover.sh
chmod +x ProPro.sh
chmod +x RecPro.sh
chmod +x Start.sh
chmod +x Stop.sh

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
		finalSize=$(bash CheckSpaceDisk.sh)
		eval $k=$finalSize
		eval val=\${"$k"}
		#export DATASIZE con el nuevo valor
		export $k
	fi

	# se loguea la accion
#	sh Glog.sh "Se estableció $v: $k" "INFO"

done 
}

<<<<<<< HEAD
#->FUNCION: Inicializar el archivo de log----------------------------------------------------------------------#
#    Se utiliza el archivo InsPro.log
#  1->Si el archivo no existe lo creo
#EXPORT: CONFDIR , AMBIENTE_INICIALIZADO

function crear_directorio()
{
	if ! [ -d $1 ]; then
		mkdir $1
		echo "Directorio $1 creado correctamente."
		echo "`date` $user : Directorio $1 creado correctamente." >> $insproLog
	fi
return 0
}

function f_inicializar_log ()
{
	inicio_instalacion="Inicio de Instalacion"

	echo "Archivo de Log inicializado"
	echo ""
	if [ -f $insproLog ]
	then
		# si existe creo otro con la fecha actual
      	  	fecha_hora_actual=`date +%S`
   		rename_insproLog=`echo $insproLog.$fecha_hora_actual`
      	 	error=`mv $insproLog $rename_insproLog`
		insproLog=`echo $rename_insproLog`
	fi

	# Grabo primer linea de archivo de Log
	inicio_instalacion=`date``users` ":" $inicio_instalacion 
	error=`echo -e $inicio_instalacion > $insproLog`
	
	return 0
}

=======
>>>>>>> refs/remotes/origin/master
#######################################

#PRINCIPAL
#######################LUIS
#export GRUPO=/home/paulo/so-7508-sisproh/Instalacion
############################


msgHeader="TP SO7508 Primer Cuatrimestre 2015. Tema H Copyright © Grupo 06"
<<<<<<< HEAD
f_inicializar_log
=======

>>>>>>> refs/remotes/origin/master
#checkeo si esta instalado
#checkInstallation

<<<<<<< HEAD

#######Luis: No se puede hacer touch porque creamos los directorios luego, es decir, el directorio de LOG y Conf no existe
#######Luis: Agrego modificacion para que los directorios se creen ni bien el usuario los ingresa 

##se crea el log de la instalacion
#insproConf="$CONFDIR/InsPro.conf"
#insproLog="$CONFDIR/InsPro.log"
#if [ ! -f $insproLog ]; then
#    touch $insproLog
#else 
#	echo "checkeando instalación"
##	bash checkSisProIns.sh
#fi

################################

####### 5. Chequear que Perl esté instalado #########

if perl < /dev/null > /dev/null 2>&1  ; then
	#checkear version
	perlResult=`perl -v | grep 'perl 5'`
	if [ "$perlResult" != "" ]; then
		echo -e "$msgHeader \n"	
		echo "Perl Version: `perl -v`"
		echo -e "\n"
	else
		echo -e "Para instalar el TP es necesario contar con Perl 5 o superior. Efectúe su instalación e inténtelo nuevamente. \n Proceso de 			Instalación Cancelado"
	fi
else
    echo -e "Para instalar el TP es necesario contar con Perl 5 o superior. Efectúe su instalación e inténtelo nuevamente. \n Proceso de 		Instalación Cancelado"
=======
#se crea el log de la instalacion
insproConf="$CONFDIR/InsPro.conf"
insproLog="$CONFDIR/InsPro.log"
if [ ! -f $insproLog ]; then
    touch $insproLog
else 
	echo "checkeando instalación"
#	bash checkSisProIns.sh
>>>>>>> refs/remotes/origin/master
fi

<<<<<<< HEAD

 
=======
####### 5. Chequear que Perl esté instalado #########

if perl < /dev/null > /dev/null 2>&1  ; then
	#checkear version
	perlResult=`perl -v | grep 'perl 5'`
	if [ "$perlResult" != "" ]; then
		echo -e "$msgHeader \n"	
		echo "Perl Version: `perl -v`"
		echo -e "\n"
	else
		echo -e "Para instalar el TP es necesario contar con Perl 5 o superior. Efectúe su instalación e inténtelo nuevamente. \n Proceso de 			Instalación Cancelado"
	fi
else
    echo -e "Para instalar el TP es necesario contar con Perl 5 o superior. Efectúe su instalación e inténtelo nuevamente. \n Proceso de 		Instalación Cancelado"
fi

#sh Glog.sh "InsPro.sh" "Inicio de la Ejecución de InsPro" "INFO"
#sh Glog.sh "InsPro.sh" "Directorio predefinido de Configuracion: $CONFDIR" "INFO"
#sh Glog.sh "InsPro.sh" "Log de la instalación: $insproLog" "INFO"

>>>>>>> refs/remotes/origin/master
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

	 ./Glog.sh "InsPro.sh" "Inicio de la Ejecución de InsPro" "INFO"
	 ./Glog.sh "InsPro.sh" "Directorio predefinido de Configuracion: $CONFDIR" "INFO"
	 ./Glog.sh "InsPro.sh" "Log de la instalación: $insproLog" "INFO"



	#llamo a la funcion para que imprima las variables
	bash CheckSisProIns.sh "showVariables"

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


######## 20. Instalación #################


######## 20. Instalación #################

if [ "$confirmInstall" = "s" ]; then
	echo "Creando Estructuras de directorio...."
##############LUIS############
	
#############################
	for (( i=0;i<11;i++)); do
		k="${array_key[$i]}"
		eval finalDir=\${"$k"}
		
		if [ "$k" != "DATASIZE" ] || [ "$k" != "LOGSIZE" ]; then	
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
################LUIS####################
insproConf="$CONFDIR/InsPro.conf"

	crear_directorio $CONFDIR
if [ ! -f $insproConf ]; then
    touch $insproConf
else 
	echo "checkeando instalación"
	bash CheckSisProIns.sh
fi
#####################################				

echo -e "\n"
echo -e "Instalando Archivos Maestros y Tablas \n"

#Nombre de la carpeta que contiene los datos
dataDir="2015-1C-Datos/"

###### 20.2 mueven los archivos maestros #######
lsMaeResult=`ls $dataDir | grep '\.mae$'`
	
for f in $lsMaeResult; do
	echo -e "moviendo Mae"
	#bash Mover.sh "$dataDir$f" "$MAEDIR" "InsPro.sh"
done

###### 20.2  Se mueven los archivos tablas #######
lsTabResult=`ls $dataDir | grep '\.tab$'`

for f in $lsTabResult; do
	echo -e "moviendo Tab"	
  #bash Mover.sh "$dataDir$f" "$MAEDIR/tab" "InsPro.sh"
done

###### 20.3 Mover los ejecutables y funciones  #######
echo -e "Instalando Programas y Funciones \n"
lsScriptsResult=`ls | grep '\.sh$'`
currentDirectory=`pwd`
for f in $lsScriptsResult; do
  echo -e "No mover nada al bin"
  #bash Mover.sh "$currentDirectory/$f" "$BINDIR" "InsPro.sh"
done

###### 20.4 Actualizar el archivo de configuración  #######
echo -e "Actualizando la configuración del sistema \n"

for (( i=0;i<11;i++)); do
	k="${array_key[$i]}"
	eval finalDir=\${"$k"}
<<<<<<< HEAD
	chmod +w $insproConf
	echo "$k=$finalDir" >> $insproConf
	
	
=======
	echo "$k=$finalDir" >> $insproConf
>>>>>>> refs/remotes/origin/master
done

###### FIN ###########
echo "Instalación CONCLUIDA"

#instalacion exitosa
touch $CONFDIR/InsPro.conf

