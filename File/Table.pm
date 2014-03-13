package File::Table;
use strict;
use warnings;
use Carp;


sub new {
  my ($class, $file, @ids) = @_;
  my $self = {};
  bless $self, $class;
  
  croak "Need file\n" if ! -s $file;
  
  open (my $FILE, "<", $file) or croak "Can't open $file: $!\n";
  if (!@ids) {
    my $header = <$FILE>;
    chomp $header;
    my @fields = split /\t/, $header, -1;
    $self->colnames(@fields);
  }
  else {
    $self->colnames(@ids);
  }

  my @rows;
  while (<$FILE>) {
    chomp;
    my @fields = split /\t/, $_, -1;
    
    my $row;
    for (my $i = 0; $i < scalar @{$self->{colnames}}; $i++) {
      my $colname = ${$self->{colnames}}[$i];
      $row->{$colname} = $fields[$i];
    }
    push (@rows, $row);
  }
  
  
  $self->{'rows'} = \@rows;
  return $self;
}


# 
# col1	col2	col3
# a	foo	x
# b	bar	y
# c	foo	z
#
# Refactoring on 'col2':
# 
# col2	col1	col3
# bar	b	y
# foo	a,c	x,z
#
# If you refactor on 'col1' the return value will exactly match the input table since col1 contains unique values
sub refactor {
  my ($self, $user_cn, $header) = @_;
  $header = $header || 0;

  croak "Column name ($user_cn) that you supplied does not exist\n" unless $self->is_colname($user_cn);

  my $mm;
  foreach my $row (@{$self->{rows}}) {
    my $id_value = $row->{$user_cn};

    foreach (@{$self->{colnames}}) { 
      next if ($_ eq $user_cn);
      $mm->{$id_value}{$_}{$row->{$_}}++;
    }
  }

  my $toReturn;
  my @colnamesToPrint;
  foreach (@{$self->{colnames}}){
    push (@colnamesToPrint, $_) if ($_ ne $user_cn);
  }
  my $toPrint = join ("\t", $user_cn, @colnamesToPrint) . "\n"; 
  if ($header) {
    push (@$toReturn, $toPrint);
  }
  
  foreach my $id_val (sort keys %$mm) {
    my @values;
    foreach my $cn (@{$self->{colnames}}) {
      next if ($cn eq $user_cn);
      my $values = join(",", sort keys %{$mm->{$id_val}{$cn}});
      push (@values, $values);
    }

    $toPrint = join("\t", $id_val, @values) . "\n";
    push (@$toReturn, $toPrint);
  }

  return $toReturn;
}


sub colnames {
  my ($self, @colnames) = @_;
  if (@colnames) {
    $self->{colnames} = \@colnames;
    
    my $i = 0;
    my %mm = map { $_ => $i++ } @colnames;
  
    $self->{colnames_hash} = \%mm;
  }

  return @{$self->{'colnames'}};
}

sub is_colname {
  my ($self, $cn) = @_;
    
  (exists $self->{colnames_hash}{$cn}) ? return 1 : return 0;
}  


1;