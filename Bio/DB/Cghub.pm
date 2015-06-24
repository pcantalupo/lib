#
# Bio::DB::Cghub
#

=head1 NAME

Bio::DB::Cghub - for access to the cghub server of metadata information 

=head1 SYNOPSIS

  use Bio::DB::Cghub;
  
  my $db = Bio::DB::Cghub->new(-participant => '0bf5bbd4-d9e8-42a6-9ab5-f2c174dec12c');
  my $cgresult = $db->get_request();
  
=head1 DESCRIPTION

This class retrieves information from the cghub metadata server. 

Examples

https://cghub.ucsc.edu/cghub/metadata/analysisAttributes?analysis_id=59c2a3f0-b5b5-46e8-ba12-8c4dbc1db4bf
https://cghub.ucsc.edu/cghub/metadata/analysisAttributes?participant_id=0bf5bbd4-d9e8-42a6-9ab5-f2c174dec12c

=head1 AUTHOR

Paul Cantalupo, pcantalupo at gmail dot com

=cut

# Let the code begin...

package Bio::DB::Cghub;
use strict;
use warnings;


use parent qw(Bio::WebAgent);

our $CGHUB_SVR = 'https://cghub.ucsc.edu';
our $CGHUB_ANAL_OBJECT_URI = '/cghub/metadata/analysisObject';
our $CGHUB_ANAL_ATTR_URI = '/cghub/metadata/analysisAttributes';

our $QUERY_KEYS = {
  analysis_id => 'analysis identifier (a BAM file)',
  participant_id => 'participant (aka patient) identifier',
  disease_abbr => 'disease abbreviation',
  library_strategy => 'library strategy like RNA-Seq',
};


=head2 new

  Title   : new
  Usage   : my $db = Bio::DB::Cghub->new()
  Returns : a reference to a new Bio::DB::Cghub
  Args    : hash of optional values for db query

=cut

sub new {
  my ( $class, @args ) = @_;
  _check_args(@args);
  my $self = $class->SUPER::new(@args);
  return $self;
}


sub _check_args {
  my @args = @_;
  
  while ( my $key = shift @args ) {
    $key = lc($key);
    $key =~ s/^-//;
    
    if (!exists $QUERY_KEYS->{$key}) {
      Bio::Root::Root->throw("invalid parameter - must be one of [" . join ("] [", keys %$QUERY_KEYS) . "]");
    }
    shift @args;
  }
}


sub analysis_id {
  my $self = shift;
  if (@_) {
    my $name = shift;
    $self->{'_analysis_id'} = $name;
  }
}

sub participant_id {

}

sub disease_abbr {

}

sub library_strategy {
  my $self = shift;
  if (@_) {
    my $name = shift;
    $self->{'_library_strategy'} = $name;
  }
}



sub get_request {
  my ($self, @args) = @_;
  

  my $rq = HTTP::Request->new( GET => "https://cghub.ucsc.edu/cghub/metadata/analysisAttributes?analysis_id=59c2a3f0-b5b5-46e8-ba12-8c4dbc1db4bf");
  my $reply = $self->request($rq);
  return $reply;
}

