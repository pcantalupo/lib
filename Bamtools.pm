package Bamtools;
use strict;
use warnings;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(bam2refnumaligns
                 bamtools_stats
                 num_mapped_reads
                );


sub bam2refnumaligns {
  my ($file) = @_;
  
  unless (-e $file) {
    print STDERR "File does not exist\n";
    return -1;
  }
  
  my @result = `samtools view $file | cut -f 3 | sort | uniq -c | awk '{print \$1"\\t"\$2}'`;
  chomp(@result);
  return @result;
}

sub bamtools_stats {
  my ($file) = @_;
  return `bamtools stats -in $file`;  
}

sub num_mapped_reads {
  my (@bt_stats) = @_;
  
  my $mr;
  foreach (@bt_stats) {
    chomp;
    if (/^Mapped reads/) {
      s/Mapped reads:\s*//;
      $mr = $_;
      last;
    }
  }
  
  return $mr;
}



1;
