#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 4;

# Various ways to say "ok"
#         ok($got eq $expected, $test_name);
#         is  ($got, $expected, $test_name);
#         isnt($got, $expected, $test_name);

BEGIN {
        use_ok('IntSpan');
}


#
# Simple IntSpan of 2 spans: 1-4 and 6-8
# 
my $intspan = IntSpan->new(intarray => [ 1,2,3,4,6,7,8 ],);
my @spans = $intspan->spans();
my $numspans = scalar @spans;
my $span = join(" ", @spans);  # '1-4 6-8'
is ( $numspans, 2, "number of spans equals 2");
is ( $span, "1-4 6-8", "span is '1-4 6-8'");


#
# Calling IntSpan->new without an intarray
#
$intspan = IntSpan->new();
@spans = $intspan->spans();
$numspans = scalar @spans;
is ( $numspans, 0, "calling IntSpan->new with no intarray so number of spans equal 0");

