package Convert;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(dec2bin);
      
sub dec2bin {
   my $str = unpack("B32", pack("N", shift));
   $str =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
   return $str;
}



1;
