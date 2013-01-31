#!/usr/bin/perl -w
use strict;
use cghub;
use Data::Dumper;
use Getopt::Long;

# example: my_cgquery.pl -d LIHC -l RNA-Seq    (gets all RNA-Seq results for LIHC)
#          my_cgquery.pl -p 0bf5bbd4-d9e8-42a6-9ab5-f2c174dec12c   (get results for a particular person)

my ($pid, $aid, $did, $lid);
GetOptions ("participant|p=s" => \$pid,
            "analysis|a=s"    => \$aid,
            "disease|d=s"     => \$did,
            "library|l=s"     => \$lid,
            );

exec("echo specify -p, -a, -d, or -l") unless ($pid || $aid || $did || $lid);

my @parts;
push (@parts, "state=live");
push (@parts, "participant_id=$pid")   if $pid;
push (@parts, "analysis_id=$aid")      if $aid;
push (@parts, "disease_abbr=$did")     if $did;
push (@parts, "library_strategy=$lid") if $lid;

my $query = join("&", @parts);

my @out = run_cgquery($query);
print @out, "\n";


