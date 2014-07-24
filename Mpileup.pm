package Mpileup;
use strict;
use warnings;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(is_mutated del_indels numGATC);


# A position is mutated if the majority base is not the reference base.
# Example: reference base is 25% (T) and the other bases GAC are 25% - this position is NOT mutated
#          reference base is 50% or more - this position is NOT mutated
#          another base is 50% or more - this position is mutated
sub is_mutated {
  my ($refbase, $reads, $alignment) = @_;

  my $is_mutated = 0;
  my $maxperc = 0;
  my $maxbase = uc $refbase;

  if ($reads >= 1 && $alignment ne '*') {      # zero read positions are not mutated and skipping * positions for now
    $alignment = del_indels($alignment);
    
    $maxperc = ($alignment =~ tr/\.,//)/$reads * 100;
    
    if ($maxperc < 50) {                     # positions with refperc >= 50% are not mutated    
      my %nGATC = numGATC($alignment);  
      foreach (keys %nGATC) {
        next if ($_ eq $refbase);
        my $perc = $nGATC{$_}/$reads * 100;
        if ($perc > $maxperc) {
          $maxperc = $perc;
          $maxbase = $_;
        }
      }
      
      if ($refbase ne $maxbase) {
        $is_mutated = 1;
      }
    }
  }

  return wantarray ? ($is_mutated, $maxbase, $maxperc) : $is_mutated;
}


# remove indel encoding from the Alignment field (field #5 of mpileup output)
# i.e. g-1t       => g
#      ,.+1G..+1G => ,...
sub del_indels {
  my ($a) = @_;
  $a =~ s/[\-+]\d+[GATC]+//gi;
  return $a;
}



# returns the number of GATC's in an Alignment field
sub numGATC {
  my ($alignment, $del_indels) = @_;
  my %toReturn;
  
  if ($del_indels) {
    $alignment = del_indels;
  }
  
  foreach (qw/G A T C/) {
    $toReturn{$_} = () = $alignment =~ /$_/gi;
  }
  
  %toReturn;
}




1;
