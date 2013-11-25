package SeqUtils;
use strict;
use warnings;
use Exporter;
use Bio::SeqUtils;
use Bio::Seq;

our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = qw(has_nsf
                  );


sub has_nsf {
  my ($seq) = @_;
  
  unless (ref $seq eq 'Bio::Seq') {
    # convert raw sequence into a Bio::Seq
    $seq = Bio::Seq->new(-seq => $seq, -id => "foobar");
  }

   my @orfs_6frames = Bio::SeqUtils->translate_6frames($seq);

   my $toReturn = 0;
   foreach my $orfseq (@orfs_6frames) {
   # search for at least one frame that does not have a stop codon '*'
      if ($orfseq->seq !~ /\*/) {   # if you don't find an '*', the sequence contains an ORF throughout entire frame
         $toReturn = 1;
      }
   }

   return $toReturn;
}



1;
