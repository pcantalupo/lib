#!/usr/bin/env perl
use strict;
use warnings;
use Mpileup;

while (<>) {

  chomp;
  my (undef, $pos, $refbase, $reads, $alignment) = split (/\t/, $_);
  
  my ($is_mut, $maxbase, $maxperc) = is_mutated($refbase, $reads, $alignment);
  
  if ($is_mut) {
    print join("\t", $pos, $refbase, $reads, $alignment, $is_mut, $maxbase, $maxperc),"\n";
  }
  
}

