#!/usr/bin/perl
use strict;
use warnings;
use Bio::DB::Cghub;
use Data::Dumper;

my $db = Bio::DB::Cghub->new(-analysis_id => '59c2a3f0-b5b5-46e8-ba12-8c4dbc1db4bf');

print Dumper ($db);

my $reply = $db->get_request;

print Dumper ($reply);


