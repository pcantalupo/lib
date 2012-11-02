package RegexUtils;


use strict;
use warnings;


# from http://perldoc.perl.org/perlmod.html
BEGIN {
	use Exporter   ();
	our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
	
	# set the version for version checking
	$VERSION     = 1.00;
	# if using RCS/CVS, this may be preferred
	#$VERSION = sprintf "%d.%03d", q$Revision: 1.1 $ =~ /(\d+)/g;

	@ISA         = qw(Exporter);
	@EXPORT      = qw(show_regex_matches);
	%EXPORT_TAGS = ( );     # eg: TAG => [ qw!name1 name2! ],

	# your exported package globals go here,
	# as well as any optionally exported functions
	@EXPORT_OK   = qw();
}



sub show_regex_matches {

	print $/,
	      "Pre:\n>", defined $` ? $` : "", "<",   $/,
	      "Match:\n>", defined $& ? $& : "", "<", $/,
	      "Post:\n>",  defined $' ? $' : "", "<",
	      $/;
}


1;
