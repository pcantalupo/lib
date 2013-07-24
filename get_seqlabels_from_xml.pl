#!/usr/bin/env perl
use strict;
use warnings;


while (<>) {
  
  if (/<SEQUENCE/) {
    my ($a, $s);
    /accession="(\S+)"/;
    $a = $1;
    /seq_label="(\S+)"/;
    $s = $1;
    
    print "$a\t$s\n" if ($a && $s);
  }
}
