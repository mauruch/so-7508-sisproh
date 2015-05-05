************************************************************** 
*****    INSTRUCCIONES PARA LA INSTALACION DEL SISTEMA   ***** 
*****                   				 ***** 	                    
**************************************************************
Requisitos: 
	Version 5 o superior de Perl. 
	Interprete Bash. 

1. Crear la carpeta GRUPO06 en $HOME/GRUPO06

2. Dentro de la carpeta debe tener la carpeta /conf y /pruebas

3. Tiene que estar la carpeta 2015-1C-Datos

4. Todos los .sh


Correr el script "InsPro.sh", mediante el comando bah, � bash Inspro.sh�


Si es la primera vez que lo corre, se mostrar�n unos mensajes 
informativos y el estado de instaci�n; de lo contrario, se le 
informar� que el sistema ya se encuentra instalado 

A continuac�n se deber�n especificar los directorios en los 
cuales se proceder� a instalar todos los componentes. Por 
defecto se proponen algunos directorios, puede optar por cam- 
biarlos o dejar la opci�n en blanco y aceptarlos. 

Confirmar la instalaci�n. 

Una vez concluida la instalaci�n, puede revirsar el archivo 
de log situado en el directorio. Tambi�n puede consul- 
tar el archivo de configuraci�n del sistema en el directorio 
$CONFDIR. 

A continuaci�n se deber� ejecutar el script IniPro.sh que 
pondr� a correr al demonio. Para eso: 
1 - Ir al directorio que se haya elegido para la instalacion. 
2 - Situarse dentro del directorio /grupo06/bin. 
3 - Ejecutar el script de la siguiente manera: 
	bash IniPro.sh


Agregar en el directorio $NOVEDIR los archivos que desee 
procesar. Los resultados aparecer�n en 
los directorios: 
$RECHDIR: si eran archivos err�neos. 
$PROCDIR: si pudieron ser procesados. 

Para realizar consultas, corrar la aplicacion infPro.pl. En 
ella encontr� un comando que despliaga la ayuda necesaria 
para su ejecuci�n. 


Gracias por usar nuestro sistema. 

*****************************************************************
