#!/usr/bin/env perl
use strict;
use warnings;
use Test::More  tests => 3;

BEGIN {
  use_ok('Bamtools');
}

my $file = "data/kv.vrs.hg19.bam";
my @refaligns = bam2refnumaligns($file);
my $numrows = @refaligns;
is ( $numrows, 13, "number of unique reference sequences");

# bam2refnumaligns returns an array of lines containing two fields separated
# by a tab.  So this test will fail if there are not 2 fields in all rows
# and if a separator other than a tab was used.
my $nfields = 2;
foreach (@refaligns) {
  my @fields = split (/\t/, $_);
  if (@fields != $nfields) {
    $nfields = scalar @fields;
    last;
  }
}
is ($nfields, 2, "number of fields returned by bam2refnumaligns is 2");

