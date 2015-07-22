#!/usr/bin/env perl
use strict;
use warnings;
use LWP::Simple;

my $base = "https://tcga-data.nci.nih.gov/uuid/uuidws/mapping/json/barcode/";

while (<>) {
  chomp;
  my $url = $base . $_;
  my $content = get($url);
  $content =~ /\"uuid\":\"(\S+)\"}}/; 
  if (!defined $1) {
    print "\n";
    print STDERR "$_ is not valid barcode\n";
  }
  else {
    print $1,"\n";
  }
}

#"uuidMapping":{"barcode":"TCGA-CA-6716-01A-11R-1839-07","uuid":"de926d40-12cd-4aba-bb2e-10d2f7768f49"}}
