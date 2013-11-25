#!/usr/bin/env perl
use strict;
use warnings;
use Bio::SeqIO;
use Test::More tests => 5;

# Various ways to say "ok"
#         ok($got eq $expected, $test_name);
#         is  ($got, $expected, $test_name);
#         isnt($got, $expected, $test_name);

BEGIN {
        use_ok('SeqUtils');
}


# Testing Bioperl formatted sequences
my $seqio = Bio::SeqIO->new(-file => "data/sequences.fa");
my $seq = $seqio->next_seq();
is (has_nsf($seq), 1, "first sequence (ctg180) has nsf");

$seq = $seqio->next_seq();
is (has_nsf($seq), 0, "second sequence (ctg174) does not have nsf");


# Testing raw sequences
open (my $in, "<", "data/rawsequences.fa");
my $rawseq = <$in>;
chomp($rawseq);
is (has_nsf($rawseq), 1, "first rawsequence (ctg180) has nsf");

$rawseq = <$in>;
chomp($rawseq);
is (has_nsf($rawseq), 0, "second rawsequence (ctg174) does not have nsf");


