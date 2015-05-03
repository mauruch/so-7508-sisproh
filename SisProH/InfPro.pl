#!/bin/perl
#Comando para la Obtención de Informes y estadísticas

#• Es el cuarto en orden de ejecución
#• Se dispara manualmente
#• No graba en el archivo de log
#• InfPro No debe ejecutar si la inicialización de ambiente no fue realizada
#• InfPro No debe ejecutar si ya existe otro comando InfPro en ejecución

#No lo entendí muy bien que hace el InfPro.pl así que hago lo que creo que pide:

#Me fijo que esté inicializado el ambiente, o sea me fijo si existen las cosas con las que voy a trabajar
$checkEmisores = "MAEDIR/emisores.mae";
$checkNormas = "MAEDIR/normas.mae";
$checkGestiones = "MAEDIR/gestiones.mae";
$checkInfodir = "INFODIR";
$checkProcdir = "PROCDIR";
#Y lo meto en un array para usar un foreach, porque el foreach es lo mas grande que hay, como manaos
@arrayDeCheckeos = ($checkEmisores,$checkNormas,$checkGestiones,$checkInfodir,$checkProcdir);

foreach $check (@arrayDeCheckeos){
	if (! -e "$check"){
		print "No se encuentra $check\n";		
	}
}


if ($ARGV[0] eq '-a'){
	&menuAyuda;
	exit;
}

if ($ARGV[0] eq '-c' or $ARGV[0] eq '-cg'){
	&menuConsulta;
	exit;
}

if ($ARGV[0] eq '-i' or $ARGV[0] eq '-ig'){
	&menuInforme;
	exit;
}

if ($ARGV[0] eq '-e' or $ARGV[0] eq '-eg'){
	&menuEstadistica;
	exit;
}

#Si llego acá es porque no ingresó ningun comando
&menuSuperAyuda;

sub menuAyuda {
	print "\n\t\tMenu de ayuda\n\n";
	print "-e muestra estadísticas de documentos ya protocolizados\n";
	print "-c le permitirá consultar sobre documentos protocolizados\n";
	print "-i se muestran informes de los archivos de consultas previas\n";
	print "-eg -cg -ig además de su función guarda en un archivo los resultados obtenidos\n\n";
	exit;
}

sub menuConsulta {
	my ($opcionUno, @opcionDos, @opcionTres, $opcionCuatro, $opcionCinco, $opcionesTipeadas, @opcionesElegidas);
	my ($flagUno, $flagDos, $flagTres, $flagCuatro, $flagCinco);
	my ($desde, $hasta, $eligioOpcion);
	$eligioOpcion = 0;
	$flagUno = 0;
	$flagDos = 0;
	$flagTres = 0;
	$flagCuatro = 0;
	$flagCinco = 0;
	while ($eligioOpcion != 1){
		print "\n\t\tMenu de consulta\n\n";
		print "Seleccione un filtro que desee aplicar, debe seleccionar almenos uno\n";
		print "Filtrar por:\n";
		print "1_Tipo de norma (todas, una)\n";
		print "2_Año (todos, rango)\n";
		print "3_Número de norma (todas, rango)\n";
		print "4_Gestión (todas, una)\n";
		print "5_Emisor (todos, uno)\n";
		#Y aca el usuario escribe cuales quiere y lo meto en un array
		$opcionesTipeadas = <STDIN>;
		@opcionesElegidas = split(/\s/, $opcionesTipeadas);
		#vuelve foreach, vamos foreach!
		foreach $numerinSacado (@opcionesElegidas){
			#perdon por la cascada de ifs si les molesta la puedo transformar en función
			if ($numerinSacado == 1){
				$flagUno = 1;
			}
			else{
				if ($numerinSacado == 2){
					$flagDos = 1;
				}
				else{
					if ($numerinSacado == 3){
					$flagTres = 1;
					}
					else{
						if ($numerinSacado == 4){
							$flagCuatro = 1;
						}
						else{
							if ($numerinSacado == 5){
								$flagCinco =1;
							}
						}
					}
				}
			}
			#fin de la cascada, prometo no hacerlo de nuevo... o si?
		}
		#Veo que por lo menos haya elegido uno, sino se arma la podrida
		if ($flagUno==1 or $flagDos==1 or $flagTres==1 or $flagCinco==1 or $flagCinco==1){
			$eligioOpcion = 1;
		}
	}

	#Ahora pregunto que valor quiere por cada opción elegida
	if ($flagUno){
			print "\nElija un tipo de norma\n";
			$opcionUno = <STDIN>;
			chomp($opcionUno);
	}
	else {
			$opcionUno = "";	#Que la linea vacia signifique todas
	}

	if ($flagDos){		
		print "Desde:\n";
		$desde = <STDIN>;
		chomp($desde);
		print "Hasta:\n";
		$hasta = <STDIN>;
		chomp($hasta);
		@opcionDos = ($desde, $hasta);
	}
	else{
			@opcionDos = (1810, 2100);	#Del año 1810 al 2100
	}

	if ($flagTres){
		print "Desde:\n";
		$desde = <STDIN>;
		chomp($desde);
		print "Hasta:\n";
		$hasta = <STDIN>;
		$hasta = <STDIN>;
		@opcionDos = ($desde, $hasta);
	}
	else{
		@opcionTres = (0,9999);	#desde donde hasta donde van las normas?
	}

	if ($flagCuatro){
		print "Escriba la gestión a buscar:\n";
		$opcionCuatro = <STDIN>;
		chomp($opcionCuatro);
	}
	else{
		$opcionCuatro = "";
	}

	if ($flagCinco){
		print "Escriba emisor a buscar:\n";
		$opcionCinco = <STDIN>;
		chomp($opcionCinco);
	}
	else{
		$opcionCinco = "";
	}

	####Ahora que tengo todo debería mostrarle la data
	print "Mostrar data seleccionada:";
	&menuPreguntaSiSeguirConsultando;
}

sub menuPreguntaSiSeguirConsultando {
	my($opcionElegida);

	print "\n¿Desea realizar otra consulta?[S/N]\n";
	$opcionElegida = <STDIN>;
	$opcionElegida = uc $opcionElegida;
	chomp($opcionElegida);
	while($opcionElegida ne 'S' and $opcionElegida ne 'N'){		
		print "\n¿Desea realizar otra consulta?[S/N]\n";
		$opcionElegida = <STDIN>;
		$opcionElegida = uc $opcionElegida;
		chomp($opcionElegida);
	}
	if ($opcionElegida eq 'S'){
		&menuConsulta;
	}
	exit;
}

sub menuInforme {
	print "\n\t\tMenu de informe\n\n";
}

sub menuEstadistica {
	print "\n\t\tMenu de estadistica\n\n";
}

sub menuSuperAyuda {
	print "\n\t\tMenu de super ayuda\n\n";
	print "Para utilizar este comando:\n";
	print "InfPro.pl opción claveDeBusqueda(opcional)\n";
	print "opción: -a ayuda, -e estadísticas, -eg estadísticas y guardar resultado\n";
	print "-i informe, -ig informe y guardar resultados\n";
	print "-c consulta, -cg consulta y guardar resultados\n\n";
	print "claveDeBusqueda: Sólo válido para -i -ig -c -cg\n";
	print "para el caso de -c o -cg se debe indicar palabra clave a buscar\n";
	print "para el caso de -i o -ig se debe indicar uno o varios nombres de archivos\n\n";
	exit;
}