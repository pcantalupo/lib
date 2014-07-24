#!/usr/bin/env perl
use strict;
use warnings;
use File::Table;
use Getopt::Long;

my $header;
my $regex;
my $file;
my $id_colname;    # a column name of the AIDINFO table
GetOptions (
            'f|file=s'   => \$file,
            'i|idname=s' => \$id_colname,
            'h|header' => \$header,
            'r|regex'  => \$regex,
            );

die "Usage $0 [-rh] FILE COLNAME\n" if (!$file || !$id_colname);

my @ids = qw/
a
analysis_data_uri
upload_date
published_date
last_modified
center
state
reason
study
l
platform
sample_accession
legacy_sample_id
d
analyte_code
st
tss_id
p
s
q
analysis_xml
run_xml
experiment_xml
filename
filesize
checksum
dat
tim
machine
flowcell
/;


my $ft = File::Table->new($file, @ids);

my $x = qr/\A(\w{4}-\w{2}-\w{4})/;
my $rows;
if ($regex) {
  $rows = $ft->refactor($id_colname, regex => $x);
}
elsif ($regex && $header) {
  $rows = $ft->refactor($id_colname, regex => $x, header => 1);
}
elsif ($header) {
  $rows = $ft->refactor($id_colname, header => 1);
}
else {
  $rows = $ft->refactor($id_colname);
}

print foreach (@$rows);

