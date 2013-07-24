#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;

my $human_accfile;
GetOptions ("humanacc|h=s" => \$human_accfile);

my $humfile;
my %humacc = ();
if ($human_accfile) {
  open ($humfile, "<", $human_accfile);
  while (<$humfile>) {
    chomp;
    $humacc{$_}++;
  }
}

while (<>) {
  
  if (/<SEQUENCE/) {
    my ($a, $s);
    /accession="(\S+)"/;
    $a = $1;
    /seq_label="(\S+)"/;
    $s = $1;
    
    next unless ($a && $s);

    if ($humfile) {
      print "$a\t$s\n" if (exists $humacc{$a});
    } else {
      print "$a\t$s\n";
    }
  }
}
