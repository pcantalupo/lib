#!/usr/bin/perl env
package IntSpan;
use strict;
use warnings;

# params
#  intarray - reference to an array of sorted integers (must be Sorted!)
sub new {
  my ($class, %args) = @_;
  my $self = bless {}, $class;

  if (exists $args{intarray}) {
    $self->{_intarray} = $args{intarray};
  }  
  return $self;
}


sub spans {
  my ($self) = @_;
  
  my @spans = ();
  if (exists $self->{_intarray}) {
    my $curint;
    my $prevint = -10;
    my $curspan;
    foreach my $curint (@{$self->{_intarray}}) {
      if ($curint - $prevint > 1) {
        if ($prevint == -10) {
          $curspan = $curint;
          $prevint = $curint;
        }
        else {
          $curspan .= "-$prevint";
          push (@spans, $curspan);
          
          $curspan = $curint;
          $prevint = $curint;
        }
      }
      else {
        # within a span so just update prevint
        $prevint = $curint;
      }
    }
    $curspan .= "-$prevint";
    push (@spans, $curspan);
  } 
  return wantarray ? @spans : scalar @spans;
}                                                             

1;

                                                                