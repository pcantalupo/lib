#!/opt/sam/perl/5.16.2/gcc45/bin/perl
use strict;
use warnings;
use cghub;

foreach (@ARGV) {
  print analysis_date_from_xml( $_ ),"\n";
}

