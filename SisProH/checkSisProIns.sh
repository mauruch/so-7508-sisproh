#!/bin/bash

insproConf=$CONFDIR/InsPro.conf

function checkInstallation {
if [ -f $insproLog ]; then
    echo "Imprimo todas las variables"
fi
}


if perl < /dev/null > /dev/null 2>&1  ; then
      perl -v
else
      echo dang... no perl
fi




function showVariables {

array_key=( "CONFDIR" "BINDIR" "MAEDIR" "NOVEDIR" "ACEPDIR" "RECHDIR" "PROCDIR" "INFODIR" "DUPDIR" "LOGDIR" )

array_value=( "Directorio de Configuración" "Directorio de Ejecutables" "Directorio de Maestros y Tablas" "Directorio de recepción de documentos para protocolización" "el directorio de grabación de las Novedades aceptadas" "Directorio de Archivos Aceptados" "Directorio de Archivos Rechazados" "Directorio de Archivos Protocolizados" "Directorio para informes y estadísticas" "Nombre para el repositorio de duplicados" "Directorio para Archivos de Log" )



}
