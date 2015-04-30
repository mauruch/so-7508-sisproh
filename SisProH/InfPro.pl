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
#Y lo meto en un array para usar un foreach
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

if ($ARGV[0] eq '-c'){
	&menuConsulta;
	exit;
}

if ($ARGV[0] eq '-i'){
	&menuInforme;
	exit;
}

if ($ARGV[0] eq '-e'){
	&menuEstadistica;
	exit;
}

#Si llego acá es porque no ingresó ningun comando
&menuSuperAyuda;

sub menuAyuda {
	print "Menu de ayuda\n";
}

sub menuConsulta {
	print "Menu de consulta\n";
}

sub menuInforme {
	print "Menu de informe\n";
}

sub menuEstadistica {
	print "Menu de estadistica\n";
}

sub menuSuperAyuda {
	print "Menu de super ayuda\n";
}