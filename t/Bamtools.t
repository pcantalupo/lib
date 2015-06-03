#!/usr/bin/env perl
use strict;
use warnings;
use Test::More  tests => 5;

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


my $expected_stats = '
**********************************************
Stats for BAM file(s): 
**********************************************

Total reads:       1473
Mapped reads:      1473	(100%)
Forward strand:    632	(42.9056%)
Reverse strand:    841	(57.0944%)
Failed QC:         0	(0%)
Duplicates:        0	(0%)
Paired-end reads:  0	(0%)

';

my @bt_stats = bamtools_stats($file);
my $bt_stats = join("", @bt_stats);
is($bt_stats, $expected_stats, "bamtools stats ok");

my $mr = num_mapped_reads(@bt_stats);
is($mr, '1473	(100%)', 'num mapped reads ok');

