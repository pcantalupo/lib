package Hela;
use strict;
use warnings;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(getpolymorphs
                select_hela_positions
                has_del_region_coverage
                );

# return rows in file for all hela positions. The position column default is 2
sub select_hela_positions {
  my ($file, $field) = @_;
  $field //= 2;
  
  open (my $m, "<", $file);
  
  my @toReturn;
  my %poly = getpolymorphs();
  while (<$m>) {
    chomp;
    my $pos = (split /\t/, $_)[$field-1];
    push (@toReturn, $_) if (exists $poly{$pos});
  }
  close ($m);
  
  return @toReturn;
}


# using mpileup output, report whether there is any coverage of the deleted
# region (from 3089 to 5735, inclusive)
sub has_del_region_coverage {
  my ($mpileupfile) = @_;
  open (my $m, "<", $mpileupfile);
  
  my $start_del = 3089;
  my $end_del   = 5735;
  
  my $coverage = 0;
  while (<$m>) {
    my (undef, $pos, undef, $reads) = split /\t/, $_;
    
    if ($reads >= 1 && $pos >= $start_del && $pos <= $end_del) {
      $coverage = 1;
    }
    last if ($coverage == 1);
  }
  
  return $coverage;
}


sub getpolymorphs {
  return (
    104 => 'C',
    287 => 'G',
    485 => 'C',
    549 => 'A',
    751 => 'T',
    806 => 'A',
    1012 => 'T',
    1194 => 'A',
    1353 => 'A',
    1807 => 'C',
    1843 => 'G',
    2269 => 'T',
    5875 => 'A',
    6401 => 'G',
    6460 => 'G',
    6625 => 'G',
    6842 => 'G',
    7258 => 'A',
    7486 => 'T',
    7529 => 'A',
    7567 => 'C',
    7592 => 'C',
    7670 => 'T',
    );
}



1;
