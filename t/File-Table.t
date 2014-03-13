#!/usr/bin/env perl
use strict;
use warnings;
use Test::More; #  tests => 8;
use Test::Files;

BEGIN {
  use_ok('File::Table');
}

#
# Testing foobar.tsv table
#

my $ft = File::Table->new("data/foobar.tsv");

my $colnames = join(",", $ft->colnames);
is ($colnames, "col1,col2,col3", "checking colnames of foobar.tsv");

my $predicted = <<HEREDOC;
col2\tcol1\tcol3
bar\tb\ty
foo\ta,c\tx,z
HEREDOC
my $rows = $ft->refactor("col2", 1);
is ( join("", @$rows), $predicted, "refactoring foobar.tsv on col2");



#
# Testing aidinfo10.tsv table
#

my @ids = qw/a analysis_data_uri upload_date published_date last_modified center
state reason study l platform sample_accession legacy_sample_id d analyte_code
st tss_id p s q analysis_xml run_xml experiment_xml filename filesize
checksum dat tim machine flowcell/;

my $file = "data/aidinfo10.tsv";
$ft = File::Table->new("data/aidinfo10.tsv", @ids);

# refactoring on the 1st column that has unique values will return a table that exactly matches the input file
my $mm = join(  "", @{$ft->refactor("a")}   );       
file_ok($file, $mm, "refactoring $file on AID");

# refactor on Disease (with column names)
$mm = join(  "", @{$ft->refactor("d", 1)}   );
file_ok("data/aidinfo10_refactor_disease.tsv", $mm, "refactoring $file on DISEASE with column names");



done_testing();