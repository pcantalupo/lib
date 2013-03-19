#!/opt/sam/perl/5.16.2/gcc45/bin/perl -w
use strict;
use cghub;

# parse cgquery text output into 1 row per result with fields separated by tabs
my $file = shift;
open (FILEIN, "<", $file) or die "Can't open $file: $!\n";

my $slurpedfile = join ('', <FILEIN>);

cgresult2tsv($slurpedfile);


