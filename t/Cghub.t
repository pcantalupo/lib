# -*-Perl-*- Test Harness script for Bioperl
# $Id$

use strict;

BEGIN {
	use lib '.';
	use Bio::Root::Test;
	test_begin(-tests => 3);
	use_ok('Bio::DB::Cghub');
}

my $db = Bio::DB::Cghub->new();
isa_ok($db, "Bio::DB::Cghub");

$db = Bio::DB::Cghub->new(-analysis_id => 'analysis_id=59c2a3f0-b5b5-46e8-ba12-8c4dbc1db4bf');
isa_ok($db, "Bio::DB::Cghub");

