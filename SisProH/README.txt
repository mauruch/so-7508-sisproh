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


Correr el script "InsPro.sh", mediante el comando bah, “ bash Inspro.sh”


Si es la primera vez que lo corre, se mostrarán unos mensajes 
informativos y el estado de instación; de lo contrario, se le 
informará que el sistema ya se encuentra instalado 

A continuacón se deberán especificar los directorios en los 
cuales se procederá a instalar todos los componentes. Por 
defecto se proponen algunos directorios, puede optar por cam- 
biarlos o dejar la opción en blanco y aceptarlos. 

Confirmar la instalación. 

Una vez concluida la instalación, puede revirsar el archivo 
de log situado en el directorio. También puede consul- 
tar el archivo de configuración del sistema en el directorio 
$CONFDIR. 

A continuación se deberá ejecutar el script IniPro.sh que 
pondrá a correr al demonio. Para eso: 
1 - Ir al directorio que se haya elegido para la instalacion. 
2 - Situarse dentro del directorio /grupo06/bin. 
3 - Ejecutar el script de la siguiente manera: 
	bash IniPro.sh


Agregar en el directorio $NOVEDIR los archivos que desee 
procesar. Los resultados aparecerán en 
los directorios: 
$RECHDIR: si eran archivos erróneos. 
$PROCDIR: si pudieron ser procesados. 

Para realizar consultas, corrar la aplicacion infPro.pl. En 
ella encontrá un comando que despliaga la ayuda necesaria 
para su ejecución. 


Gracias por usar nuestro sistema. 

*****************************************************************
