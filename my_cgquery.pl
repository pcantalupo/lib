#!/usr/bin/env perl
use strict;
use warnings;
use cghub;
use Data::Dumper;
use Getopt::Long;

# example: my_cgquery.pl -d LIHC -l RNA-Seq
#               gets all RNA-Seq results for LIHC
#          my_cgquery.pl -p 0bf5bbd4-d9e8-42a6-9ab5-f2c174dec12c
#               get results for a particular person
#          my_cgquery.pl -d KIRC -l RNA-Seq -x "PROGRAM>MapspliceRSEM" (or "PROGRAM>RNAseqAlignmentBWA" for other pipeline)
#               get MapspliceRSEM pipeline results for RNA-Seq of KIRC 

my ($pid, $aid, $did, $lid, $qid, $lastmod, $xmltext, $nolive);
my $study = "phs000178";             # default is the TCGA study
my $outputxml = "";
my $attr = 1;                 # get analysisAttribute (-a flag) not analysisObject information
GetOptions ("participant|p=s" => \$pid,
            "analysis|a=s"    => \$aid,
            "disease|d=s"     => \$did,
            "library|l=s"     => \$lid,
            "aliquot|q=s"     => \$qid,
            "xmltext|x=s"     => \$xmltext,
            "outputxml|o=s"   => \$outputxml,
            "attr|r"          => \$attr,              # specify -r on commandline if you don't want analysisAttributes
            "lastmod|m=s"     => \$lastmod,
            "study|s=s"       => \$study,
            "nolive|v"        => \$nolive,            # specify -v on command line if you don't state=live
            );

exec("echo specify -p, -a, -d, -l, -q") unless ($pid || $aid || $did || $lid || $qid || $xmltext);

my @parts;
push (@parts, "state=live")            unless ($nolive);
push (@parts, "study=phs000178")       if $study;
push (@parts, "participant_id=$pid")   if $pid;
push (@parts, "analysis_id=$aid")      if $aid;
push (@parts, "disease_abbr=$did")     if $did;
push (@parts, "library_strategy=$lid") if $lid;
push (@parts, "aliquot_id=$qid")       if $qid;
push (@parts, "last_modified=[$lastmod]")if $lastmod;
push (@parts, "xml_text=$xmltext")     if $xmltext;

my $query = join("&", @parts);

my $cg_args;
$cg_args->{xml} = $outputxml;
$cg_args->{attr} = $attr;
my @out = run_cgquery($query, $cg_args);
print @out, "\n";

