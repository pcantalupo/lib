package Math;


require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(log2); 

sub log2 {
  my $n = shift;
  return "" if $n <= 0;
  return log($n)/log(2);
}
      

1;

