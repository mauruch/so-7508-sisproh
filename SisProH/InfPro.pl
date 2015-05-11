#!/usr/bin/perl
#!/bin/perl

use 5.010;
use Term::ANSIColor;

#Comando para la Obtención de Informes y estadísticas

#• Es el cuarto en orden de ejecución
#• Se dispara manualmente
#• No graba en el archivo de log
#• InfPro No debe ejecutar si la inicialización de ambiente no fue realizada
#• InfPro No debe ejecutar si ya existe otro comando InfPro en ejecución

#No lo entendí muy bien que hace el InfPro.pl así que hago lo que creo que pide:

#Me fijo que esté inicializado el ambiente, o sea me fijo si existen las cosas con las que voy a trabajar
$MAEDIR = $ENV{'MAEDIR'};
$INFODIR = $ENV{'INFODIR'};
$PROCDIR = $ENV{'PROCDIR'};
$checkEmisores = "$MAEDIR/emisores.mae";
$checkNormas = "$MAEDIR/normas.mae";
$checkGestiones = "$MAEDIR/gestiones.mae";
$checkInfodir = "$INFODIR";
$checkProcdir = "$PROCDIR";
%emisor;
#Y lo meto en un array para usar un foreach, porque el foreach es lo mas grande que hay, como manaos
@arrayDeCheckeos = ($checkEmisores,$checkNormas,$checkGestiones,$checkInfodir,$checkProcdir);
my $count_args = $#ARGV + 1;	#sirve o se borra?

##############
#### MAIN ####
##############
&main;
###############
# FIN DE MAIN #
###############

sub main {
	`reset`;
	&checkeos;
	&makeHashWithEmisores;
	&decideWhatToDo;
	#Si llego acá es porque no ingresó ningun comando
	&menuSuperAyuda;
}

sub makeHashWithEmisores {
	my @emisoresList;
	my ($key,$value);
	if ( open(FILE,"$checkEmisores") ) {
		while (my $row = <FILE>) {
		  chomp $row;
		  push (@emisoresList,$row);
		}		
		close(FILE);
	}
	else{
		print "No se pudo abrir $checkEmisores";
		exit;
	}
	foreach $line (@emisoresList) {
		$key = `echo "$line" | cut -d ';' -f 1`;
		chomp($key);
		$value = `echo "$line" | cut -d ';' -f 2`;
		chomp($value);
		$emisor{$key} = $value;	
	}
}

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
	#Checkeo que no se esté ejecutando ya
	$checkIfAlreadyRunningLikeASpeedRunner = `ps -a | grep InfPro.pl\$`;
	chomp($checkIfAlreadyRunningLikeASpeedRunner);
	if ($checkIfAlreadyRunningLikeASpeedRunner ne ""){

		my $bell = chr(7);
		print $bell;
		print color("red"),"\tWARNING!!!\n",color("reset");
		print color("yellow"),"\tYa se encuentra una instancia de InfPro.pl corriendo\n",color("reset");
		sleep 3;
		print color("yellow"),"\tProcediento a auto-destruirse en 5 segundos...\n",color("reset");
		sleep 4;
		print color("green"),"\t5...\n",color("reset");
		print $bell;
		sleep 1;
		print color("green"),"\t4...\n",color("reset");
		print $bell;
		sleep 1;
		print color("blue"),"\t3...\n",color("reset");
		print $bell;
		sleep 1;
		print color("blue"),"\t2...\n",color("reset");
		print $bell;
		sleep 1;
		print color("red"),"\t1...\n",color("reset");
		print $bell;
		sleep 1;
		print color("red"),"\tBOOM!!!!!!!!\n",color("reset");
		exit;
	}

	#Acá checkeo si el ambiente fue inicializado
	if ($MAEDIR eq ''){
		print "No se ha inicializado el ambiente\n";
		print "Ejecute en la terminal \". IniPro.sh\"\n";
		exit;
	}

	foreach $check (@arrayDeCheckeos){
		if (! -e "$check"){
			print "No se encuentra $check\n";
			exit;
		}
		else{
			`chmod +rw $check`;
		}
	}
}

sub menuAyuda {
	print color("red"),"\n\t\tMenu de ayuda\n\n",color("reset");
	print "-e muestra estadísticas de documentos ya protocolizados\n";
	print "-c le permitirá consultar sobre documentos protocolizados\n";
	print "-i se muestran informes de los archivos de consultas previas\n";
	print "-eg -cg -ig además de su función guarda en un archivo los resultados obtenidos\n\n";
	exit;
}

######################################################################################################################################
######################################################################################################################################
######################################################################################################################################
######################################################################################################################################
######################################################################################################################################

sub menuConsulta {
	&mostrarDataConsultas( &setOptionValuesConsulta(&getflagsConsulta) );	
}

sub mostrarDataConsultas {
	my ($opcionUno,$opcionDosDesde,$opcionDosHasta,$opcionTresDesde,$opcionTresHasta,$opcionCuatro,$opcionCinco) = @_;
	my (@gestionDirectory, @gestionDirectoryAProcesar);
	my ($currentDirToProcess);
	my(@filesToProcess, @filteredData,@sortedData,%filteredDataHash);
	`reset`;
	####Ahora que tengo todo debería mostrarle la data
	@filesToProcess = &applyFilterGestion($opcionCuatro);											#Opción Cuatro
	@filesToProcess = &applyFilterEmisor($opcionCinco, @filesToProcess);							#Opción Cinco
	@filesToProcess = &applyFilterYear($opcionDosDesde,$opcionDosHasta,@filesToProcess);			#Opción Dos
	@filesToProcess = &applyFilterCodigoNorma($opcionUno, @filesToProcess);							#Opción Uno
	@filteredData = &applyFilterNumeroNorma($opcionTresDesde,$opcionTresHasta,@filesToProcess);		#Opción Tres

	if ($#filteredData != -1){
		if ($ARGV[0] eq '-cg') {
			#Y aca debería escribir en un archivo
				my $salir = 0;
				my $contador = 1;
				my $filePath;
				while ( $salir == 0) {	
					$filePath = "$INFODIR/resultados_$contador";
					if ( -e $filePath ){
						$contador +=1;
					}
					else {
						$salir = 1;
					}
				}
				unless(open FILE, '>'."$filePath") {
					die "Unable to create $filePath";
				}
		}
	
			if ($#ARGV >= 1) {
				my $knowIfData = 0;
				#significa que quiere filtrar por algo más
				%filteredDataHash = &applyFilterKeyword(@filteredData);
				#Y esto que sigue no lo puedo meter en una funcion porque le tendría que pasar un hash y un array
				foreach my $theKey (sort { $filteredDataHash{$b} <=> $filteredDataHash{$a} } keys %filteredDataHash) {
		   			if ($filteredDataHash{$theKey} > 0) {
		   				$knowIfData = 1;
		   				my @keyArrayed = split (";", $theKey);
						$codigoGestion = `echo $keyArrayed[0] | cut -d '_' -f 1`;
						chomp ($codigoGestion);
						$codigoNorma = `echo $keyArrayed[0] | cut -d '_' -f 2`;
						chomp ($codigoNorma);
						$codigoEmisor = `echo $keyArrayed[0] | cut -d '_' -f 3`;
						chomp ($codigoEmisor);
		   				#TODO tengo el codigo de emisor pero no el emisor, de ultima leo el archivo y me armo el hash
		   				print "############################################################################################\n";  		
		   				print "$codigoNorma $emisor($codigoEmisor) $keyArrayed[2]/$keyArrayed[3] $codigoGestion $keyArrayed[1] Peso=$filteredDataHash{$theKey}\n";
		   				print "$keyArrayed[4]\n";
		   				print "$keyArrayed[5]\n";   						
		   				if ($ARGV[0] eq '-cg') {
		   					#Y aca debería escribir en un archivo
						print FILE "$codigoNorma;$emisor{$codigoEmisor};$codigoEmisor;$keyArrayed[2];$keyArrayed[3];$codigoGestion;$keyArrayed[1];$keyArrayed[4];$keyArrayed[5];$keyArrayed[10]";   				}#Fin del guardado
					}
				}
				if ($knowIfData == 0){
					print "No se han encontrado resultados\n";
				}
			}
			else{
				#ordenar cronológicamente
				%filteredDataHash = &makeHashWithDates(@filteredData);
				#http://stackoverflow.com/questions/2491471/how-can-i-sort-dates-in-perl
				foreach my $theKey (sort { join('', (split '/', $a)[2,1,0]) cmp join('', (split '/', $b)[2,1,0]) } keys %filteredDataHash) {
					my @keyArrayed = split (";", $theKey);			
					$codigoGestion = `echo $keyArrayed[0] | cut -d '_' -f 1`;
					chomp ($codigoGestion);
					$codigoNorma = `echo $keyArrayed[0] | cut -d '_' -f 2`;
					chomp ($codigoNorma);
					$codigoEmisor = `echo $keyArrayed[0] | cut -d '_' -f 3`;
					chomp ($codigoEmisor);
					#TODO tengo el codigo de emisor pero no el emisor, de ultima leo el archivo y me armo el hash
					print "############################################################################################\n";  		
		   			print "$codigoNorma $emisor{$codigoEmisor}($codigoEmisor) $keyArrayed[2]/$keyArrayed[3] $codigoGestion $keyArrayed[1]\n";
					print "$keyArrayed[4]\n";
					print "$keyArrayed[5]\n";
					if ($ARGV[0] eq '-cg') {
						#Y aca debería escribir en un archivo
						print FILE "$codigoNorma;$emisor{$codigoEmisor};$codigoEmisor;$keyArrayed[2];$keyArrayed[3];$codigoGestion;$keyArrayed[1];$keyArrayed[4];$keyArrayed[5];$keyArrayed[10]"; 
					}
				}
			}
	
			if ($ARGV[0] eq '-cg') {
				close FILE;
			}
	}
	else {
		print "   No se han encontrado resultados\n";
	}

	&menuPreguntaSiSeguirConsultando;
}

sub makeHashWithDates {
	my (@filteredData) = @_;
	my (%retvalhash,$date,$extracto,@wordsCausante,@wordsExtracto);

	foreach $lineOfData (@filteredData) {
		$date = `echo "$lineOfData" | cut -d ';' -f 2`;	#veo que esta en la segunda, ya que en la primera está la fuente
		chomp ($date);
		$retvalhash{$lineOfData} = $date;
	}
	return (%retvalhash);	
}

sub applyFilterKeyword {
	my (@filteredData) = @_;
	my (%retvalhash,$causante,$extracto,@wordsCausante,@wordsExtracto);

	foreach $lineOfData (@filteredData) {
		my $totalPowerOfTheLineOfData = 0;
		$causante = `echo "$lineOfData" | cut -d ';' -f 5`;
		$extracto = `echo "$lineOfData" | cut -d ';' -f 6`;

		@wordsCausante = split(" ",$causante);
		@wordsExtracto = split(" ",$extracto);

		foreach $word (@wordsCausante) {
			#por cada vez que encuentre la palabra en el causante le sumo 10
			if ($ARGV[1] eq $word) {
				$totalPowerOfTheLineOfData += 10;
			}
		}
		foreach $word (@wordsExtracto) {
			#Lo mismo que el anterior pero ahora con el extracto, aca le sumo 1
			if ($ARGV[1] eq $word) {
				$totalPowerOfTheLineOfData += 1;
			}
		}
		$retvalhash{$lineOfData} = $totalPowerOfTheLineOfData;
	}
	return (%retvalhash);
}

sub applyFilterNumeroNorma {
	#acá ya me voy a tener que meter adentro del archivo
	my ($numeroNormaDesde,$numeroNormaHasta,@filesToProcess) = @_;
	my (@retval, @currentlyFiltering,@chompedFiltering);
	
	if ($numeroNormaDesde == -1){
		foreach (@filesToProcess){
			push (@retval,`cat $_`);
		}
		return (@retval);
	}
	else{
		foreach (@filesToProcess){
			push (@currentlyFiltering,`cat $_`);			
		}
		foreach (@currentlyFiltering){
			#le saco los espacios
			chomp($_);		
			push (@chompedFiltering,$_);
		}
		foreach $filteredLine (@chompedFiltering){
			$numeroDeNormaSacado = `echo "$filteredLine" | cut -d ';' -f 3`;
			chomp($numeroDeNormaSacado);
			if ( ($numeroDeNormaSacado >= $numeroNormaDesde) and ($numeroDeNormaSacado <= $numeroNormaHasta) ){
				push (@retval, $filteredLine);
			}
		}
		return (@retval);
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
		$norma = `basename $totalPath`;	#el cut es para files será basename?		
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
	chomp ($yearsWantedFrom);
	chomp ($yearsWantedTo);

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
		$year = `basename $totalPath`;	#el cut es para files		
		chomp($year);
		$year = `echo "$year" | cut -d '.' -f 1`;		
		chomp($year);
		if (($year >= $yearsWantedFrom) and ($year <= $yearsWantedTo)){
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
	my ($gestionAFiltrar) = @_;
	my (@retval);
	#TODO cambiar el hardcodeo
	my (@gestionDirectory) = `ls $PROCDIR`;
	my ($baseDir) = "$PROCDIR/";

	if ($gestionAFiltrar ne ""){		
		foreach (@gestionDirectory){
			chomp ($_);
			if ($_ eq $gestionAFiltrar and $_ ne "proc"){
				@retval = ("$baseDir$_/");
			}
		}
	}
	else {
		foreach (@gestionDirectory){
			chomp ($_);
			if ($_ ne "proc"){
				push (@retval, "$baseDir$_/");
			}
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
			print "\nElija un tipo de norma\n";
			print ">";
			$opcionUno = <STDIN>;
			chomp($opcionUno);
	}
	else {
			$opcionUno = "";	#Que la linea vacia signifique todas
	}

	if ($flagDos){		
		print "\nAño desde:\n";
		print ">";
		$desde = <STDIN>;
		chomp($desde);
		print "\nAño hasta:\n";
		print ">";
		$hasta = <STDIN>;
		chomp($hasta);
		@opcionDos = ($desde, $hasta);
	}
	else{
			@opcionDos = (-1, 2100);	#Del año -1 al 2100
	}

	if ($flagTres){
		print "\nNúmero de norma desde:\n";
		print ">";
		$desde = <STDIN>;
		chomp($desde);
		print "\nNúmero de norma hasta:\n";
		print ">";
		$hasta = <STDIN>;
		chomp($hasta);
		@opcionTres = ($desde, $hasta);
	}
	else{
		@opcionTres = (-1,-1);	#Como para que elija todas
	}

	if ($flagCuatro){
		print "\nEscriba la gestión a buscar:\n";
		print ">";
		$opcionCuatro = <STDIN>;
		chomp($opcionCuatro);
	}
	else{
		$opcionCuatro = "";
	}

	if ($flagCinco){
		print "\nEscriba emisor a buscar:\n";
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
		print color("red"),"\n\t\tMenu de filtros\n\n",color("reset");
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

	print color("red"),"\t¿Desea realizar otra consulta?[S/N]\n",color("reset");
	$opcionElegida = <STDIN>;
	$opcionElegida = uc $opcionElegida;
	chomp($opcionElegida);
	while($opcionElegida ne 'S' and $opcionElegida ne 'N'){		
		print color("red"),"\t¿Desea realizar otra consulta?[S/N]\n",color("reset");
		$opcionElegida = <STDIN>;
		$opcionElegida = uc $opcionElegida;
		chomp($opcionElegida);
	}
	if ($opcionElegida eq 'S'){
		&menuConsulta;
	}
	exit;
}

######################################################################################################################################
######################################################################################################################################
######################################################################################################################################
######################################################################################################################################
######################################################################################################################################

sub menuInforme {
	print color("red"),"\n\t\tMenu de informe\n\n", color("reset");
	my $keyWord = &palabraClaveABuscar;
	&mostrarDataInformes($keyword, ( &setOptionValuesConsulta(&getflagsConsulta) ) );
	&menuPreguntaSiSeguirViendoInformes;
}

sub mostrarDataInformes {
	my ($keyWord,$opcionUno,$opcionDosDesde,$opcionDosHasta,$opcionTresDesde,$opcionTresHasta,$opcionCuatro,$opcionCinco) = @_;
	my (@filesToProcess, @dataToFilter);
	`reset`;

	if ($ARGV[0] eq '-ig') {
		#Y aca debería escribir en un archivo
		my $salir = 0;
		my $contador = 1;
		my $filePath;
		while ( $salir == 0) {	
			$filePath = "$INFODIR/informes_$contador";
			if ( -e $filePath ){
				$contador +=1;
			}
			else {
				$salir = 1;
			}
		}
		unless(open FILE, '>'."$filePath") {
			die "Unable to create $filePath";
		}
	}

	if($#ARGV == 0){
		@filesToProcess = `ls \$INFODIR  | grep ^resultados_`;
	}
	else{
		my $cont = 0;
		foreach $argument (@ARGV){
			if ($cont > 0){
				$argument = "resultados_$argument";
				push(@filesToProcess,$argument);
			}
			$cont += 1;
		}
	}

	@dataToFilter = &filterInformeTipoNorma($opcionUno,@filesToProcess);
	if ($opcionDosDesde != -1){
		@dataToFilter = &filterInformeYear($opcionDosDesde,$opcionDosHasta,@dataToFilter);
	}	#Lo aplico sólo si no lo dejé vacío
	if ($opcionTresDesde != -1){
		@dataToFilter = &filterInformeNumeroNorma($opcionTresDesde,$opcionTresHasta,@dataToFilter);
	}	#Lo aplico sólo si no lo dejé vacío
	if ($opcionCuatro ne ""){
		@dataToFilter = &filterInformeGestion($opcionCuatro,@dataToFilter);
	}	#Lo aplico sólo si no lo dejé vacío
	if ($opcionCinco ne ""){
		@dataToFilter = &filterInformeEmisor($opcionCinco,@dataToFilter);
	}	#Lo aplico sólo si no lo dejé vacío
	if ($keyWord ne ""){
		my %hashValues = &filterInformeKeyWord($keyWord,@dataToFilter);
		my $knowIfData = 0;
		foreach my $theKey (sort { $filteredDataHash{$b} <=> $filteredDataHash{$a} } keys %filteredDataHash) {
			if ($filteredDataHash{$theKey} > 0) {
				$knowIfData = 1;
				my @keyArrayed = split (";", $theKey);
				$codigoGestion = `echo $keyArrayed[0] | cut -d '_' -f 1`;
				chomp ($codigoGestion);
				$codigoNorma = `echo $keyArrayed[0] | cut -d '_' -f 2`;
				chomp ($codigoNorma);
				$codigoEmisor = `echo $keyArrayed[0] | cut -d '_' -f 3`;
				chomp ($codigoEmisor);
				#TODO tengo el codigo de emisor pero no el emisor, de ultima leo el archivo y me armo el hash
				print "############################################################################################\n";  		
				print "$theKey";   						
				if ($ARGV[0] eq '-ig') {
					#Y aca debería escribir en un archivo
					print FILE "$theKey";   				
				}#Fin del guardado
			}
		}
		if ($knowIfData == 0){
			print "No se han encontrado resultados\n";
		}
	}
	else {
		if ($#dataToFilter != -1){
			my (%filteredDataHash,$date);

			foreach $lineOfData (@dataToFilter) {
				$date = `echo "$lineOfData" | cut -d ';' -f 7`;	#veo que esta en la segunda, ya que en la primera está la fuente
				chomp ($date);
				$filteredDataHash{$lineOfData} = $date;
			}
			#http://stackoverflow.com/questions/2491471/how-can-i-sort-dates-in-perl
			foreach my $theKey (sort { join('', (split '/', $a)[2,1,0]) cmp join('', (split '/', $b)[2,1,0]) } keys %filteredDataHash) {
				print "############################################################################################\n";  		
				print "$theKey";
				if ($ARGV[0] eq '-ig') {
					#Y aca debería escribir en un archivo
					print FILE "$theKey";
				}
			}
		}
		else{
			print "No se han encontrado resultados\n";
		}

	}
}

sub menuPreguntaSiSeguirViendoInformes {
	my($opcionElegida);

	print color("red"),"\t¿Desea realizar otro informe?[S/N]\n",color("reset");
	$opcionElegida = <STDIN>;
	$opcionElegida = uc $opcionElegida;
	chomp($opcionElegida);
	while($opcionElegida ne 'S' and $opcionElegida ne 'N'){		
		print color("red"),"\t¿Desea realizar otra consulta?[S/N]\n",color("reset");
		$opcionElegida = <STDIN>;
		$opcionElegida = uc $opcionElegida;
		chomp($opcionElegida);
	}
	if ($opcionElegida eq 'S'){
		&menuInforme;
	}
	exit;
}

sub filterInformeKeyWord {
	my ($keyWord,@dataToFilter) = @_;
	
	my (%retvalhash,$causante,$extracto,@wordsCausante,@wordsExtracto);

	foreach $lineOfData (@dataToFilter) {
		my $totalPowerOfTheLineOfData = 0;
		$causante = `echo "$lineOfData" | cut -d ';' -f 8`;
		$extracto = `echo "$lineOfData" | cut -d ';' -f 9`;

		@wordsCausante = split(" ",$causante);
		@wordsExtracto = split(" ",$extracto);

		foreach $word (@wordsCausante) {
			#por cada vez que encuentre la palabra en el causante le sumo 10
			if ($keyWord eq $word) {
				$totalPowerOfTheLineOfData += 10;
			}
		}
		foreach $word (@wordsExtracto) {
			#Lo mismo que el anterior pero ahora con el extracto, aca le sumo 1
			if ($keyWord eq $word) {
				$totalPowerOfTheLineOfData += 1;
			}
		}
		$retvalhash{$lineOfData} = $totalPowerOfTheLineOfData;
	}
	return (%retvalhash);

}

sub filterInformeGestion {
	my ($gestion,@dataToFilter) = @_;

	foreach $line (@dataToFilter){
		$gestionSacada = `echo "$line" | cut -d ';' -f 6`;
		chomp($gestionSacada);
		chomp($line);
		if ( "$gestionSacada" eq "$gestion" ){				
			push (@retval, $line);
		}
	}
	return (@retval);
}

sub filterInformeNumeroNorma {
	my ($normaDesde,$normaHasta,@dataToFilter) = @_;

	foreach $line (@dataToFilter){
		$normita = `echo "$line" | cut -d ';' -f 4`;
		chomp($normita);
		if (($normita >= $normaDesde) and ($normita <=$normaHasta)){
			chomp($line);
			push (@retval, $line);
		}
	}
	return (@retval);
}

sub filterInformeYear {
	my ($yearDesde,$yearHasta,@dataToFilter) = @_;

	foreach $line (@dataToFilter){
		$year = `echo "$line" | cut -d ';' -f 5`;
		chomp($year);
		if (($year >= $yearDesde) and ($year <=$yearHasta)){
			chomp($line);
			push (@retval, $line);
		}
	}
	return (@retval);
}

sub filterInformeTipoNorma {
	my ($tipoNorma,@filesToProcess) = @_;
	my (@retval, @files,@chompedFiltering);

	foreach (@filesToProcess) {
		$dirOfFile = "$INFODIR/$_";
		push (@files,$dirOfFile);
	}
	
	if ($tipoNorma eq ''){
		foreach $filedir (@files){
			if(-e $filedir ){
				push (@retval,`cat $filedir`);
			}
		}
		return (@retval);
	}
	else{
		foreach (@files){
			if(-e $filedir ){
				push (@currentlyFiltering,`cat $_`);
			}		
		}
		foreach (@currentlyFiltering){
			#le saco los espacios
			chomp($_);		
			push (@chompedFiltering,$_);
		}
		foreach $filteredLine (@chompedFiltering){
			$tipoNormaSacado = `echo "$filteredLine" | cut -d ';' -f 1`;
			chomp($tipoNormaSacado);
			if ( "$tipoNormaSacado" eq "$tipoNorma" ){				
				push (@retval, $filteredLine);
			}
		}
		return (@retval);
	}
}

sub palabraClaveABuscar {
	my $retval;
	print "   Elija palabra Clave a buscar\n";
	$retval = <STDIN>;
	$retval = uc $retval;	#uc es upper case
	chomp($retval);
	return $retval;
}

######################################################################################################################################
######################################################################################################################################
######################################################################################################################################
######################################################################################################################################
######################################################################################################################################

sub menuEstadistica {
	print color("red"),"\n\t\tMenu de estadistica\n\n", color("reset");
	&mostrarDataEstadistica(&setOptionValuesEstadistica);
}

sub mostrarDataEstadistica {
	`reset`;
	my ($yearDesde,$yearHasta,$gestion) = @_;
	my (@filesToProcess);

	@filesToProcess = &applyFilterGestion($gestion);
	@filesToProcess = &applyFilterYear($yearDesde,$yearHasta,@filesToProcess);
	&mostrarLasEstadisticas(@filesToProcess);
	&menuPreguntaSiSeguirViendoEstadisticas;
}

sub mostrarLasEstadisticas {
	my (@filesToProcess) =@_;
	my (@dataContent,%hashYears);

	if ($ARGV[0] eq '-eg') {
	#Y aca debería escribir en un archivo
		my $salir = 0;
		my $contador = 1;
		my $filePath;
		while ( $salir == 0) {	
			$filePath = "$INFODIR/estadisticas_$contador";
			if ( -e $filePath ){
				$contador +=1;
			}
			else {
				$salir = 1;
			}
		}
		unless(open FILE, '>'."$filePath") {
			die "Unable to create $filePath";
		}
	}

	%hashYears = &getHashYears(@filesToProcess);
	$knowIfData = 0;
	foreach my $theKey (sort { $hashYears{$a} <=> $hashYears{$b} } keys %hashYears) {
		$knowIfData = 1;
		chomp($theKey);
		my $gestion = `echo $theKey | rev | cut -d '/' -f 2 | rev`;
		chomp ($gestion);
		my $yearAndCodigoNorma = `basename "$theKey"`;
		chomp($yearAndCodigoNorma);
		my $year = `echo "$yearAndCodigoNorma" | cut -d '.' -f 1`;
		chomp($year);
		my $codigoNorma = `echo "$yearAndCodigoNorma" | cut -d '.' -f 2`;
		chomp($codigoNorma);
		my $emisorKey = `head -1 "$theKey" | cut -d '_' -f 3`;		
		chomp($emisorKey);
		$resoluciones = 0;
		$disposiciones = 0;
		$convenios = 0;
		if ("$codigoNorma" eq 'RES'){
			$resoluciones = `wc -l < $theKey`;
			chomp($resoluciones);
		}
		if ("$codigoNorma" eq 'DIS'){
			$disposiciones = `wc -l < $theKey`;
			chomp($disposiciones);
		}
		if ("$codigoNorma" eq 'CON'){
			$convenios = `wc -l < $theKey`;
			chomp($convenios);
		}
		print "Gestión:$gestion Año:$year Emisores:$emisor{$emisorKey}\n";
		print "Cantidad de resoluciones: $resoluciones\n";
		print "Cantidad de disposiciones: $disposiciones\n";
		print "Cantidad de convenios: $convenios\n";
		print "#################################################################\n";

		if ($ARGV[0] eq '-eg') {
		print FILE "Gestión:$gestion Año:$year Emisores:$emisor{$emisorKey}\nCantidad de resoluciones: $resoluciones\nCantidad de disposiciones: $disposiciones\nCantidad de convenios: $convenios\n###################################\n";
		}
	}
	if ($knowIfData == 0){
		print "No se han encontrado resultados\n";
	}
}

sub menuPreguntaSiSeguirViendoEstadisticas {
	my($opcionElegida);

	print color("red"),"\t¿Desea realizar otra estadística?[S/N]\n",color("reset");
	$opcionElegida = <STDIN>;
	$opcionElegida = uc $opcionElegida;
	chomp($opcionElegida);
	while($opcionElegida ne 'S' and $opcionElegida ne 'N'){		
		print color("red"),"\t¿Desea realizar otra estadística?[S/N]\n",color("reset");
		$opcionElegida = <STDIN>;
		$opcionElegida = uc $opcionElegida;
		chomp($opcionElegida);
	}
	if ($opcionElegida eq 'S'){
		&menuEstadistica;
	}
	exit;
}

sub getHashYears {
	my (@filesToProcess) = @_;
	my (%retval);

	foreach $directory (@filesToProcess){	
		$var = `basename $directory`;
		$var = `echo "$var" | cut -d '.' -f 1`;
		chomp($var);
		$retval{$directory} = $var;
	}
	return (%retval);
	
}

sub setOptionValuesEstadistica {	
	my ($yearDesde,$yearHasta,$gestion,@retval);

	print "\nElija filtro de año desde (enter para todos los años)\n";
	print ">";
	$yearDesde = <STDIN>;
	chomp($yearDesde);
	if ("$yearDesde" eq ""){
		$yearDesde = 0; 	#Que la linea vacia signifique todas
		$yearHasta = 9999;
	}
	else{
		print "\nElija filtro de año hasta\n";
		print ">";
		$yearHasta = <STDIN>;
		chomp($yearHasta);
	}	

	print "\nEscriba la gestión a buscar (enter para todos las gestiones)\n";
	print ">";
	$gestion = <STDIN>;
	chomp($gestion);
	
	@retval = ($yearDesde,$yearHasta,$gestion);
}

sub menuSuperAyuda {    
    print color("red"),"\n\t\tMenu de super ayuda\n\n", color("reset");
	print "   Para utilizar este comando:\n";
	print "   InfPro.pl opción claveDeBusqueda(opcional)\n";
	print "   opción: -a ayuda, -e estadísticas, -eg estadísticas y guardar resultado\n";
	print "   -i informe, -ig informe y guardar resultados\n";
	print "   -c consulta, -cg consulta y guardar resultados\n\n";
	print "   claveDeBusqueda: Sólo válido para -i -ig -c -cg\n";
	print "   para el caso de -c o -cg se debe indicar palabra clave a buscar\n";
	print "   para el caso de -i o -ig se debe indicar uno o varios nombres de archivos\n\n";
	exit;
}