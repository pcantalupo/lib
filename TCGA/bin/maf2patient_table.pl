#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;

my %patients;
my %symbols;
while (<>) {
  chomp;
  next if ($_ =~ /^#|^Hugo_/);

  my ($symbol, $barcode) = (split /\t/, $_)[0,15];

  my $pbc = substr($barcode, 0,12);
  
  $patients{$pbc}{$symbol} = "MUT";
  
  $symbols{$symbol}++;
  
}

my @sorted_symbols = sort keys %symbols;

print join ("\t", "PatientBarcode", @sorted_symbols),"\n";

foreach my $pbc (sort keys %patients) {
  my @symbolinfo = map { (exists $patients{$pbc}{$_}) ? $patients{$pbc}{$_} : "NOT_MUT";  } @sorted_symbols;

  print join ("\t", $pbc, @symbolinfo), "\n";
}


