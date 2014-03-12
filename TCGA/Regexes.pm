package TCGA::Regexes;
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
  @EXPORT      = qw(uuid_regex patient_barcode_capture);
  %EXPORT_TAGS = ( );     # eg: TAG => [ qw!name1 name2! ],
                        # your exported package globals go here,
                        # as well as any optionally exported functions
  @EXPORT_OK   = qw();
}


sub uuid_regex {
  qr/ \A          # beginning of string
      \w{8}-      # first group of 8 characters
      (\w{4}-){3} # set of three tokens of 5 characters each
      \w{12}      # last group of 12 characters
      \Z          # end of string
  /x;

  # 5f1399ef-8100-49e7-806f-9f532e55c0ba

}


# Captures patient barcode (1st twelve characters below) into $1 if it exists at the beginning of the string
# TCGA-CM-6677-01A-11D-1835-10
# ^^^^^^^^^^^^
#
sub patient_barcode_capture {
  qr/  \A
       (\w{4}-
        \w{2}-
        \w{4}
       )
  /x;

  #TCGA-AA-3520
}

1;


