#!/usr/bin/env perl
use strict;
use warnings;
use cghub;

foreach (@ARGV) {
  print analysis_date_from_xml( $_ ),"\n";
}

