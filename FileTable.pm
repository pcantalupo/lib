package FileTable;
use strict;
use warnings;

sub new{
	my $class = shift;
	my $self = {};
	my $f = shift;
	my $d = shift;
	my $stream = shift;
	my @ids = @_;
	die "$d: Need delimiter \n" if !$d;
	die "$f: File not found\n" if ! -s $f;
	my $s;
	open $s,"$f";
	my @rows;
	if(!@ids){
		my $h = <$s>;
		@ids = Header($h,$d);	
	}
	if(!$stream){
		while(<$s>){
			next if $_ =~ /^\#/ || $_ =~ /^\s+$/;	
			my %mm = HashLine($_,$d,@ids);
			push(@rows,\%mm);
		}
		$self->{'rows'} = \@rows;
	}
	else{
		$self->{'stream'} = $s;	
	}
	$self->{'columns'} = \@ids;
	$self->{'delim'} = $d;
	bless $self, $class;
	return $self;	
}
sub NextHash{
	my $self = shift;
	die "Stream not set\n" if !$self->{'stream'};
	my $s = $self->{'stream'};
	my $line = <$s>;
	return HashLine($line,$self->{'delim'},@{$self->{'columns'}}) if defined($line) && $line !~ /^\s+$/;
	return;
}	
sub HashLine{
	my $line = shift;
	my $d = shift;	
	my @ids = @_;
	my %toReturn;
	$line =~ s/\s+$|^\s+//g;
	#print $line,$/;
	my @cols = split /$d/,$line;
	for(my $i = 0; $i < scalar @ids; $i++){
		#print $ids[$i],$/;
		$cols[$i] =~ s/\'|\"//g if $cols[$i];
		$toReturn{$ids[$i]} = $cols[$i];
	}
	return %toReturn;
}
sub AddColumn{
	my $self = shift;
	my $in_key = shift;
	my $hash = shift;
	foreach my $r (@{$self->{'rows'}}){
		my $i = $r->{$in_key};
		foreach my $k (keys %{$hash->{$i}}){
			$r->{$k} = $hash->{$i}{$k};
		}
	}	
}
sub Array{
	my $self = shift;
	return @{$self->{'rows'}};	
}
sub Hash{ # update to Hash key
	my $self = shift;
	my $key = shift;
	my %toReturn;
	foreach my $r (@{$self->{'rows'}}){
		my $k = $r->{$key};
		$toReturn{$k} = $r;
	}	
	return %toReturn;
}
sub HashIndex{
	my $self = shift;
	my $key = shift;
	my $value = shift;
	my %toReturn;
	foreach my $r (@{$self->{'rows'}}){
		my $k = $r->{$self->{'columns'}[$key]};
		if(defined($value)){
			my $v = $r->{$self->{'columns'}[$value]};
			$toReturn{$k} = $v;
		}
		else{
			$toReturn{$k} = $r;
		}
	}	
	return %toReturn;
}
sub HashArray{
	my $self = shift;
	my $key = shift;
	my %toReturn;
	foreach my $r (@{$self->{'rows'}}){
		my $k = $r->{$key};
		$toReturn{$k} = [] if !$toReturn{$k};
		push(@{$toReturn{$k}}, $r);
	}	
	return %toReturn;
}
sub Get{
	my $self = shift;
	my $key = shift;
	return $self->{$key};	
}
sub Header{
	my $h = shift;
	my $d = shift;
	chomp $h;
	my @hs = split /$d/, $h;
	for(my $i = 0; $hs[$i]; $i++){
		$hs[$i] =~ s/\"|\'//g;	
	}
	return @hs;
}
sub Print{
	my $self = shift;
	my $file = shift;
	my $delim = shift;
	my @cols = @{shift @_};
	my $header = shift;
	@cols = @{$self->{'columns'}} if !@cols;
	open OUT, ">$file";
	if($header){
		print OUT join($delim,@cols),$/;
	}
	foreach my $r (@{$self->{'rows'}}){
		my @toPrint;
		foreach my $c (0..scalar(@cols)-1){
			my $k = $cols[$c];
			#$r->{$k} = '' if !$r->{$k};
			push(@toPrint,$r->{$k});
		}
		print OUT join($delim,@toPrint),$/;
	}
}
1;