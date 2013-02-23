#!/usr/bin/perl -w
use strict;
use cghub;
use Data::Dumper;
use Getopt::Long;

# example: my_cgquery.pl -d LIHC -l RNA-Seq    (gets all RNA-Seq results for LIHC)
#          my_cgquery.pl -p 0bf5bbd4-d9e8-42a6-9ab5-f2c174dec12c   (get results for a particular person)

my ($pid, $aid, $did, $lid, $qid, $xmltext);
my $outputxml = "";
my $attr = 1;                 # get analysisAttribute not analysisObject information
GetOptions ("participant|p=s" => \$pid,
            "analysis|a=s"    => \$aid,
            "disease|d=s"     => \$did,
            "library|l=s"     => \$lid,
            "aliquot|q=s"     => \$qid,
            "xmltext|x=s"     => \$xmltext,
            "outputxml|o=s"   => \$outputxml,
            "attr|r"          => \$attr,              # specify -r on commandline if you don't want analysisAttributes
            );

exec("echo specify -p, -a, -d, -l, -q") unless ($pid || $aid || $did || $lid || $qid || $xmltext);

my @parts;
push (@parts, "state=live");
push (@parts, "participant_id=$pid")   if $pid;
push (@parts, "analysis_id=$aid")      if $aid;
push (@parts, "disease_abbr=$did")     if $did;
push (@parts, "library_strategy=$lid") if $lid;
push (@parts, "aliquot_id=$qid")       if $qid;
push (@parts, "xml_text=$xmltext")     if $xmltext;

my $query = join("&", @parts);

my $cg_args;
$cg_args->{xml} = $outputxml;
$cg_args->{attr} = $attr;
my @out = run_cgquery($query, $cg_args);
print @out, "\n";

