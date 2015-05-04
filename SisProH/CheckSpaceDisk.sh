#!/bin/bash

#devuelve espacio en disco, por ej: 5000M
diskSizeMB=`df -Ph -BM . | awk 'NR==2 {print $4}'`

#remuevo el 'M'
size=${diskSizeMB::-1}

#mientras que el usuario no ingrese un tamaño menor que el disco
while [ $DATASIZE -gt $size ]
do
	echo "Insuficiente espacio en disco."
	echo "Espacio disponible: $size Mb."
	echo "Espacio requerido $DATASIZE Mb"
	echo "Cancele la instalación o inténtelo nuevamente."
	read newDataSize
	DATASIZE=$newDataSize
done
echo "$DATASIZE"





