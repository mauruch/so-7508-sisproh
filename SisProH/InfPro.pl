#!/usr/bin/perl
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
my $count_args = $#ARGV + 1;

&checkeos;
&decideWhatToDo;
#Si llego acá es porque no ingresó ningun comando
&menuSuperAyuda;

sub decideWhatToDo {
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
}

sub checkeos {
	foreach $check (@arrayDeCheckeos){
		if (! -e "$check"){
			print "No se encuentra $check\n";
			exit;
		}
	}
}

sub menuAyuda {
	print "\n\t\tMenu de ayuda\n\n";
	print "-e muestra estadísticas de documentos ya protocolizados\n";
	print "-c le permitirá consultar sobre documentos protocolizados\n";
	print "-i se muestran informes de los archivos de consultas previas\n";
	print "-eg -cg -ig además de su función guarda en un archivo los resultados obtenidos\n\n";
	exit;
}

sub menuConsulta {
	&mostrarDataConsultas( &setOptionValuesConsulta(&getflagsConsulta) );	
}

sub mostrarDataConsultas {
	my ($opcionUno,$opcionDosDesde,$opcionDosHasta,$opcionTresDesde,$opcionTresHasta,$opcionCuatro,$opcionCinco) = @_;
	my (@gestionDirectory, @gestionDirectoryAProcesar);
	my ($currentDirToProcess);
	my(@filesToProcess, @filteredData);
	####Ahora que tengo todo debería mostrarle la data
	@filesToProcess = &applyFilterGestion($opcionCuatro);											#Opción Cuatro
	@filesToProcess = &applyFilterEmisor($opcionCinco, @filesToProcess);							#Opción Cinco
	@filesToProcess = &applyFilterYear($opcionDosDesde,$opcionDosHasta,@filesToProcess);			#Opción Dos
	@filesToProcess = &applyFilterCodigoNorma($opcionUno, @filesToProcess);							#Opción Uno
	@filteredData = &applyFilterNumeroNorma($opcionTresDesde,$opcionTresHasta,@filesToProcess);		#Opción Tres

	&menuPreguntaSiSeguirConsultando;
}

sub applyFilterNumeroNorma {
	#acá ya me voy a tener que meter adentro del archivo
	my ($numeroNormaDesde,$numeroNormaHasta,@filesToProcess) = @_;
	my (@retval);
	print "$numeroNormaDesde";
	if ($numeroNormaDesde == -1){
		foreach (@filesToProcess){
			push (@retval,`cat $_`);
		}		
		return (@retval);
	}
	else{
		foreach (@filesToProcess){			
			$numeroDeNormaSacado = `cut -d ';' -f 3 $_`;
			#TODO falta aca
			print "$numeroDeNormaSacado";
		}
	}
}

sub applyFilterCodigoNorma {
	my ($normaFilter, @filesToProcess) = @_;
	my (@retval,$norma);

	if ($normaFilter eq ""){
		#significa que no tendré que filtrar nada
		return (@filesToProcess);
	}

	foreach $totalPath (@filesToProcess){
		$norma = `echo $totalPath | cut -d '/' -f 3`;	#el cut es para files
		chomp($norma);		
		$norma = `echo $norma | cut -d '.' -f 2`;
		chomp($norma);
		if (index($norma, $normaFilter) != -1){
			push (@retval, $totalPath);
		}
	}
	@retval;
}

sub applyFilterYear {
	my ($yearsWantedFrom,$yearsWantedTo, @filesToProcess) = @_;
	my (@retval, @filesWithTheYears, @partialFiles,$year);

	foreach $firstPartDir (@filesToProcess){
		my (@completeDir);	#como para que se resetee
		@partialFiles = `ls $firstPartDir`;
		foreach $lastPartDir (@partialFiles){			
			$var = join('',$firstPartDir,$lastPartDir);
			chomp ($var);
			push( @completeDir,$var );
		}
		push(@filesWithTheYears,@completeDir);
	}

	foreach $totalPath (@filesWithTheYears){
		$year = `echo $totalPath | cut -d '/' -f 3`;	#el cut es para files
		chomp($year);
		$year = `echo $year | cut -d '.' -f 1`;
		chomp($year);
		if (($year >= $yearsWantedFrom) and ($year <=$yearsWantedTo)){
			push (@retval, $totalPath);
		}		
	}
	@retval;	#Acá ya voy devolviendo cosas como PROCDIR/Fernandez2/2007.WASD
}

sub applyFilterEmisor {
	($emisorWanted, @filesToProcess) = @_;
	my (@retval);
	#voy a ver si los directorios que me pasan contienen el filtro por emisor, si no lo contienen lo saco
	foreach (@filesToProcess){
		if (index($_, $emisorWanted) != -1) {
	    	push (@retval, $_);
		}
	}
	@retval;	#Devuelve cosas como PROCDIR/Fernandez2/
}

sub applyFilterGestion {
	$gestionAFiltrar = $_;
	my (@retval);
	#TODO cambiar el hardcodeo
	my (@gestionDirectory) = `ls PROCDIR`;
	my ($baseDir) = "PROCDIR/";

	if ($gestionAFiltrar ne ""){		
		foreach (@gestionDirectory){
			chomp ($_);
			if ($_ eq $gestionAFiltrar){
				@retval = ("$baseDir$_/");
			}
		}
	}
	else {
		foreach (@gestionDirectory){
			chomp ($_);
			push (@retval, "$baseDir$_/");
		}
	}
	@retval;	#Devuelve cosas como PROCDIR/Fernandez2/
}

sub setOptionValuesConsulta {
	my ($desde, $hasta);
	my ($opcionUno,@opcionDos,@opcionTres,$opcionCuatro,$opcionCinco,@retval);
	($flagUno, $flagDos, $flagTres, $flagCuatro, $flagCinco) = @_;
	#Ahora pregunto que valor quiere por cada opción elegida
	if ($flagUno){
			print "Elija un tipo de norma\n";
			print ">";
			$opcionUno = <STDIN>;
			chomp($opcionUno);
	}
	else {
			$opcionUno = "";	#Que la linea vacia signifique todas
	}

	if ($flagDos){		
		print "Año desde:\n";
		print ">";
		$desde = <STDIN>;
		chomp($desde);
		print "Año hasta:\n";
		print ">";
		$hasta = <STDIN>;
		chomp($hasta);
		@opcionDos = ($desde, $hasta);
	}
	else{
			@opcionDos = (1810, 2100);	#Del año 1810 al 2100
	}

	if ($flagTres){
		print "Número de norma desde:\n";
		print ">";
		$desde = <STDIN>;
		chomp($desde);
		print "Número de norma hasta:\n";
		print ">";
		$hasta = <STDIN>;
		chomp($hasta);
		@opcionTres = ($desde, $hasta);
	}
	else{
		@opcionTres = (-1,-1);	#Como para que elija todas
	}

	if ($flagCuatro){
		print "Escriba la gestión a buscar:\n";
		print ">";
		$opcionCuatro = <STDIN>;
		chomp($opcionCuatro);
	}
	else{
		$opcionCuatro = "";
	}

	if ($flagCinco){
		print "Escriba emisor a buscar:\n";
		print ">";
		$opcionCinco = <STDIN>;
		chomp($opcionCinco);
	}
	else{
		$opcionCinco = "";
	}

	@retval = ($opcionUno,$opcionDos[0],$opcionDos[1],$opcionTres[0],$opcionTres[1],$opcionCuatro,$opcionCinco);
}

sub getflagsConsulta {
	my ($eligioOpcion,$opcionesTipeadas, @opcionesElegidas, $flagUno,$flagDos, $flagTres, $flagCuatro, $flagCinco);
	my(@retval);
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
		print ">";
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
		if ($flagUno==1 or $flagDos==1 or $flagTres==1 or $flagCuatro==1 or $flagCinco==1){
			$eligioOpcion = 1;
		}
	}
	@retval = ($flagUno,$flagDos,$flagTres,$flagCuatro,$flagCinco);
}

sub menuPreguntaSiSeguirConsultando {
	my($opcionElegida);

	print "¿Desea realizar otra consulta?[S/N]\n";
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
