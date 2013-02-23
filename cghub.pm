# cghub module
#
# Written by Paul Cantalupo

# POD documentation - main docs before the code

=head1 NAME

cghub - methods for accessing cghub

=head1 SYNOPSIS

    use cghub;


=head1 DESCRIPTION

blah

=head1 OBJECT METHODS


=head1 AUTHOR - Paul Cantalupo

Email pcantalupo@gmail.com

=cut

#' Let the code begin...

package cghub;
use strict;
use warnings;
use PBS;
use Exporter;

our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = qw(run_cgquery
                  hash_result_by_aid
                  cgresult2tsv
                  );

sub run_cgquery {
  my ($query, $args) = @_;

  my @args;
  push(@args, "cgquery");
  if ($args->{xml} ne "") {
    push(@args, "-o " . $args->{xml});
  }
  if ($args->{attr} == 1) {
    push(@args, "-a");
  }
  my $command = join(" ", @args, "'$query'");
  my $result = `$command`;  
  return $result;
}


# input: array reference to output from a cgquery
sub hash_result_by_aid {
  my $result = join ('', @{$_[0]} );

  my %h;
  while ($result =~ /^    Result \d+.*\n((^(?!\s+Result \d+).*\n)+)/gm) {
    my @rows = split /\n/, $1;
    my @output = ();
    
    my %record_info; 
    foreach (@rows) {
      s/^\s+//;
      next if (/^Files/);
      my ($name,$value) = $_ =~ /^(\S+)\s+:\s+(.*)$/;
      $record_info{$name} = $value;
    }
    
    $h{ $record_info{'analysis_id'} } = \%record_info;
  }
  
  return \%h;  
}

# Input: scalar containing resultset
# Desc: parse cgquery text output into 1 row per result with fields separated by tabs
sub cgresult2tsv {
  my $resultset = shift;

  while ($resultset =~ /^    Result \d+.*\n((^(?!\s+Result \d+).*\n)+)/gm) {
    my $result = $1;
    my @rows = split /\n/, $result;

    my @output = ();
    foreach (@rows) {
      s/^\s+//;
      next if (/^Files/);
      my ($name,$value) = $_ =~ /^(\S+)\s+:\s+(.*)$/;
      push(@output, $value);
    }
    print join("\t", @output),"\n";
  }

}

1;
