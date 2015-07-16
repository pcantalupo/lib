#!/usr/bin/env perl
use strict;
use warnings;
use LWP::Simple;

my $base = "https://tcga-data.nci.nih.gov/uuid/uuidws/mapping/json/barcode/";

while (<>) {
  my $url = $base . $_;
  #getprint $url;
  my $content = get($url);
  $content =~ /\"uuid\":\"(\S+)\"}}/; 
  print $1,"\n";
}

#"uuidMapping":{"barcode":"TCGA-CA-6716-01A-11R-1839-07","uuid":"de926d40-12cd-4aba-bb2e-10d2f7768f49"}}
