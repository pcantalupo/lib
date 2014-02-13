#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 10;

BEGIN {
   use_ok('Segmasker');
}


#
# Testing SV40 TAg
# 
my $file = "/Users/pgc92/lib/t/data/TAg.faa";
my $seg = Segmasker->new();
my ($id, $pm, $nm, $len, $ranges) = $seg->run($file);
my $range_string = join(",", @$ranges);
is ($id,'sv40T');
is ($pm, 3.67231638418079);
is ($nm, 26);
is ($len, 708);
is ($range_string, '630 - 643,696 - 707'); 


#
# Testing a Bovine Herpesvirus 5 HSP
#
my $hsp = 'WSPRPAGGGRRRGWAGAETPGAAWSGARAPRAAGRPGP';
($id, $pm, $nm, $len, $ranges) = $seg->run($hsp);
$range_string = join(",", @$ranges);

is ($pm, 81.5789473684211);
is ($nm, 31);
is ($len, 38);
is ($range_string,'5 - 16,19 - 37'); 


