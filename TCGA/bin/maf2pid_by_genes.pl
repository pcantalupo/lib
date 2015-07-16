#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

my %pids;  # pid -> gene -> yes
                 # gene2 -> no
          # pid2 ...
my %genes; # get unique names of genes
my %pbcpid;   # pbc to pid mapping

while (<>) {
  next if (/^#/);
  next if (/^Hugo_Symbol/);
  my @f = split(/\t/, $_);

  if ($f[8] ne 'Silent') {    # gene is considered mutated in patient if mutation is not "Silent"
    my $sbc = $f[15];
    my ($pbc) = $sbc =~ /^(TCGA-..-....)/;  
    my $pid;
    if (exists $pbcpid{$pbc}) {
      $pid = $pbcpid{$pbc};
    }
    else {
      my $exe = qq{barcode2uuid.pl <<<"$pbc"};
      $pid = `$exe`;
      chomp($pid);
      $pbcpid{$pbc} = $pid;
    }
    
    my $symb = $f[0];
    $genes{$symb}++;
    $pids{$pid}{$symb} = 1;
  }
  
  print STDERR "$.\n" if ($. % 1000 == 0); 
}


my @genes = sort keys %genes;
print join("\t", "pid", @genes),"\n";
foreach my $pid (keys %pids) {
  my @toPrint = ($pid);

  foreach my $symb (@genes) {
    if (exists $pids{$pid}{$symb}) {
      push (@toPrint, "yes");
    }
    else { push (@toPrint, "no") }
  }
  
  print join ("\t", @toPrint), "\n";
}


