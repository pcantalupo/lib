package BlastUtils;
use strict;
use Bio::SearchIO::Writer::TextResultWriter;

use Exporter;
our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = qw(get_result_from_blast_report 
                  write_blast_result_as_string);

# PACKAGE GLOBALS
#


# arguments: two strings (read id and blast file)
# return value: Bio::Search::Result::ResultI (need to check this) 
#            or empty string if result is not found
sub old_get_result_from_blast_report {

   my ($readid, $blastfile) = @_;
   return "" unless ($readid && $blastfile);

   unless (-e $blastfile) {
      return "";
   }
        
   my $in = Bio::SearchIO->new(-format => 'blast',
                               -file   => $blastfile);
   
   # iterate over all results
   while (my $result = $in->next_result) {
      if ($readid eq $result->query_name) {
         return $result;   # result found
      }
   }
   
   return ""               # result not found
}


sub get_result_from_blast_report {
   my ($blastfile, $readid2result) = @_;

   return unless (keys %$readid2result);
   return unless ($blastfile);
   return unless (-e $blastfile);

   my $in = Bio::SearchIO->new(-format => 'blast',
                                 -file => $blastfile);
   
   # iterate over all results
   while (my $result = $in->next_result) {
      foreach my $readid (keys %$readid2result) {
         if ($readid eq $result->query_name) {
            $$readid2result{$readid} = $result;
            last;
         }
      }   
   }
}      


sub write_blast_result_as_string {
   my ($result) = @_;
   return unless (ref $result);
   
   my $writer = Bio::SearchIO::Writer::TextResultWriter->new();
   print $writer->to_string($result);
   
   # OLD
   #my $out = Bio::SearchIO->new(-writer => $writer,
   #                                 -file  => ">$file");
   #$out->write_result($result);
}



1;
