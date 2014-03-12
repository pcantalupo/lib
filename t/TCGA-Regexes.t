#!/usr/bin/env perl
use strict;
use warnings;
use Test::More  tests => 8;

BEGIN {
  use_ok('TCGA::Regexes');
}

my @uuids = qw/ 5f1399ef-8100-49e7-806f-9f532e55c0ba
    5f1399e-8100-49e7-806f-9f532e55c0ba
    5f1399ef-8100-49e7-806f-9f532e55c0baa
    5f1399ef-810-49e7-806f-9f532e55c0baa
    5f1399ef-81000-49e7-806f-9f532e55c0baa
/;


is ( $uuids[0] =~ uuid_regex(), "1");
is ( $uuids[1] !~ uuid_regex(), "1");
is ( $uuids[2] !~ uuid_regex(), "1");
is ( $uuids[3] !~ uuid_regex(), "1");
is ( $uuids[4] !~ uuid_regex(), "1");


my $barcode = "TCGA-CM-6677-01A-11D-1835-10";
is ($barcode =~ patient_barcode_capture(), "1");
is ($1, "TCGA-CM-6677");

