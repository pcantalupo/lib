package Bamtools;
use strict;
use warnings;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(bam2refnumaligns
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



1;
