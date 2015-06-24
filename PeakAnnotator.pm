# Let the code begin
package PeakAnnotator;
use strict;
use warnings;
use Exporter;

our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = qw(peaks2genes
                  refgenehash
                  );



sub refgenehash {
  my ($refgene) = @_;
  
  open (my $rg, "<", $refgene);
  my $ref;
  while (<$rg>) {
    chomp;
    my ($chr, $s, $e, $gene, undef, $strand) = split /\t/, $_;
    $ref->{$chr}{$gene}{start} = $s;
    $ref->{$chr}{$gene}{end}   = $e;
    $ref->{$chr}{$gene}{strand}= $strand;
  }
  return $ref;
}


# arguments is peak chromosome (i.e. chr9)
#              peak start (99123456)
#              refgene hash (from refgenehash function)
# returns Gene symbol
#         Distance to gene (negative means upstream of TSS)
#         Gene start
#         Gene end
#         Gene strand
sub peaks2genes {
  my ($peakchr, $peakstart, $ref, $min, $max) = @_;
  
  if (!$min) { $min = -5000; }
  if (!$max) { $max = 1000;  }
  #my $min = -5000;   # promoter region is between 5kb upstream and
  #my $max = 1000;    # 1 kb downstream (also used for Three Prime region)

  my $closedist = 1_000_000_000;
  my $closegene = '';
  my $closetss;
  foreach my $gene (keys %{$ref->{$peakchr}}) {
    
    # set Transcriptional start site for gene based on strand
    my $tss = $ref->{$peakchr}{$gene}{start};
    if ($ref->{$peakchr}{$gene}{strand} eq '-') {
      $tss = $ref->{$peakchr}{$gene}{end};
    }

    # find closest TSS to this peak    
    my $dist = abs ($peakstart - $tss);
    if ($dist < $closedist) {
      $closedist = $dist;
      $closegene = $gene;
      $closetss  = $tss;
    }
  }
  
  if ($ref->{$peakchr}{$closegene}{strand} eq '+') {
    if ($peakstart < $closetss) {
      $closedist *= -1;
    }
  }
  else {
    if ($peakstart > $closetss) {
      $closedist *= -1;
    }
  }

  my $gs = $ref->{$peakchr}{$closegene}{start};
  my $ge = $ref->{$peakchr}{$closegene}{end};
  my $closeloc = getlocation($min, $max, $closedist, $gs, $ge);
  my $strand = $ref->{$peakchr}{$closegene}{strand};

  $closeloc //= 'NULL';
  $closegene //= 'NULL';
  $gs     //= 'NULL';
  $ge     //= 'NULL';
  $strand //= 'NULL';
  
  return  $closeloc,
          $closegene,
          $closedist,
          $gs,
          $ge,
          $strand;
}



sub getlocation {
  my ($min, $max, $dist_from_start, $gs, $ge) = @_;
  
  my $location = "";  
  if ($dist_from_start ne "" &&
      $gs              ne "" &&
      $ge              ne "") {

    my $l = $ge - $gs + 1;           # gene length
    my $z = $l - $dist_from_start;   # z is the distance to end of the gene

    if ($dist_from_start < $min || $z < $min) {
      $location = "intergenic";
    }
    elsif ($dist_from_start >= $min && $dist_from_start <= $max) {
      $location = "promoter";
    }
    elsif ($z > $max) {
      $location = "genebody";
    }
    elsif ($z >= $min && $z <= $max) {
      $location = "threeprime";
    }
    else {
      $location = "unreachable";
    }
  }

  return $location;
}


1;

