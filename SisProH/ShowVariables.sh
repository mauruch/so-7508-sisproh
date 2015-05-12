array_key=( "$CONFDIR" "$BINDIR" "$MAEDIR" "$NOVEDIR" "$DATASIZE" "$ACEPDIR" "$RECHDIR" "$PROCDIR" "$INFODIR" "$DUPDIR" "$LOGDIR" "$LOGSIZE" )

array_value=( "Directorio de Configuración" "Directorio de Ejecutables" "Directorio de Maestros y Tablas" "Directorio de recepción de documentos para protocolización" "Espacio mínimo libre para arribos [Mb]" "Directorio de Archivos Aceptados" "Directorio de Archivos Rechazados" "Directorio de Archivos Protocolizados" "Directorio para informes y estadísticas" "Nombre para el repositorio de duplicados" "Directorio para Archivos de Log" "Tamaño máximo para los archivos de log del sistema [Kb]")

elements=${#array_key[@]}

for (( i=0;i<$elements;i++ )); do

	KEY=${array_key[${i}]}

	echo -e "${array_value[${i}]}: $KEY \n"
	bash $GRUPO/Glog.sh "InsPro.sh" "${array_value[${i}]}: $KEY"

done
