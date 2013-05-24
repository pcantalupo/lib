package FileTable;

# written on 5/23/13 by Josh Katz

use strict;
use warnings;

sub new{
	my $class = shift;
	my $self = {};
	my $f = shift;
	my $d = shift;
	my @ids = @_;
	die "Need delimiter \n" if !$d;
	die "Need file then delimiter\n" if ! -s $f;
	open IN,"$f";
	my @rows;
	if(!@ids){
		my $h = <IN>;
		@ids = Header($h,$d);	
	}
	while(<IN>){
		next if $_ =~ /^\#/ || $_ =~ /^\s+$/;	
		chomp;
		my @cols = split /$d/,$_;
		my %mm;
		for(my $i = 0; $i < scalar @ids; $i++){
			$mm{$ids[$i]} = $cols[$i];
		}
		push(@rows,\%mm);
	}
	$self->{'rows'} = \@rows;
	$self->{'columns'} = \@ids;
	bless $self, $class;
	return $self;	
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

