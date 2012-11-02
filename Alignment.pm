#!/usr/bin/perl -w
package Alignment;

use strict;
use Exporter;
our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = qw(get_bess_bese);


# GLOBALS


# arguments: 5 values: QueryLength, q.s, q.e, s.s, s.e (these last 4 values
# must be unaltered from blast output).  For example, if the strand of the
# query is negative (-) in the blast hit, the q.s > q.e.  So, do not reverse
# these values before invoking this subroutine

# returns: array of two numbers (blast-extended- subject start and subject end)
#          undef if there is an error
sub get_bess_bese {
   my ($qlen, $qs, $qe, $ss, $se) = @_;
   
   my $bess = bess($qlen, $qs, $qe, $ss, $se);
   return undef if (!defined $bess);
   
   my $bese = bese($bess, $qlen);
   
   return ($bess, $bese);
}



# internal subroutine that determines the blast extended subject start
sub bess {
   my ($qlen, $qs, $qe, $ss, $se) = @_;
   
   # need to deal with four cases to determine BESS  
   my $bess = '';
   if ($qs < $qe && $ss < $se) {        # Q+ S+
      #print "1\t";

      $bess = _bess_qs_only($qs, $ss);

   } elsif ($qs < $qe && $ss > $se) {   # Q+ S-
      #print "2\t";
      
      # use end values
      $bess = _bess_qs_qlen($qlen, $qe, $se);

   } elsif ($qs > $qe && $ss < $se) {   # Q- S+
      #print "3\t";
      $bess = _bess_qs_qlen($qlen, $qs, $ss);
      
   } elsif ($qs > $qe && $ss > $se) {   # Q- S-
      #print "4\t";
      
      # use end values
      $bess = _bess_qs_only($qe, $se); 
         
   } else {
      return undef;     # something went wrong
   }

   return $bess;
}


sub _bess_qs_only {
   my ($qs, $ss) = @_;
   return $ss - ($qs - 1);
}

sub _bess_qs_qlen {
   my ($qlen, $qs, $ss) = @_;   
   return $ss - ($qlen - $qs);
}


# Internal subroutine that determines the blast extended subject start
# arguments: subject start and query length
# returns the blast extended subject end
sub bese {
   my ($start, $length) = @_;
   $start + ($length - 1);
}





1;
