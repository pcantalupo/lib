package ExcelUtils;

use strict;
use warnings;


# from http://perldoc.perl.org/perlmod.html
BEGIN {
	use Exporter   ();
	our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
	
	# set the version for version checking
	$VERSION     = 1.00;
	# if using RCS/CVS, this may be preferred
	#$VERSION = sprintf "%d.%03d", q$Revision: 1.1 $ =~ /(\d+)/g;

	@ISA         = qw(Exporter);
	@EXPORT      = qw(lastrow
                     lastcol
                     get_excel_sheet
                     excelfulltext);
	%EXPORT_TAGS = ( );     # eg: TAG => [ qw!name1 name2! ],

	# your exported package globals go here,
	# as well as any optionally exported functions
	@EXPORT_OK   = qw();
}



# Takes reference to Excel sheet object and optional field separator value
# 
# Description:
# All cells from 0 to MaxCol are joined with field separator (def: \t)
# for each row (up to MaxRow). Empty cells are set to ''. Each line is 
# terminated with \n.
#
# Array context: returns array where size of array is equal to number of rows in worksheet
# Scalar context: joins rows of spreadsheet together with empty string
#
sub excelfulltext {
	my ($sheet, $field_sep) = @_;
	return undef unless ref $sheet;  # must be 'ref $sheet' since $sheet has a value of
                                    # '0' in boolean context for the first worksheet
	
	$field_sep = $field_sep || "\t";
	
	my $last_row = lastrow($sheet);
	my $last_col = lastcol($sheet);

	my @rows = ();
	for my $row (0 .. $last_row) {
		my @cells; 
		for my $col (0 .. $last_col) {
			my $cell = $sheet->{Cells}[$row][$col];
			push @cells, ref $cell ? $cell->Value : '';
			
		}
		my $row = join ($field_sep, @cells);
		$row .= "\n";
		push @rows, $row;
	}
	
	return wantarray ? @rows : join ('', @rows);
}



sub get_excel_sheet {
	my ($xlsfile, $worksheetname) = @_;
	
	# create a ParseExcel object
	my $excel_obj = Spreadsheet::ParseExcel->new();
	my $excel = $excel_obj->Parse($xlsfile);
	
	# make sure we're in business
	die "Workbook did not return worksheets!\n"
		unless ref $excel->{Worksheet} eq 'ARRAY';
	
	my $sheet = '';	
	# find requested worksheet
	foreach $sheet (@{$excel->{Worksheet}}) {
		if ($sheet->{Name} =~ m/$worksheetname/i) {
#		if ($sheet->{Name} =~ m/Deep Well plate map/i) {
			return $sheet;
		}
	}

	return '';
}

sub lastrow {
  my $sheet = shift;
  return $sheet->{MaxRow} || 0;
}

sub lastcol {
  my $sheet = shift;
  return $sheet->{MaxCol} || 0;
}


1;




__END__
# All cells are joined with \t and the line is terminated with \n
#
# Array context: Returns array where 'scalar @array' equals number of lines
#                in worksheet.
# Scalar context: Joins array elements together in one scalar with empty string.
# 
# this method does not fill in empty cells with \t
# for example, if the MaxCol in the Sheet is 5 (6 cols total)
# and the second cell of the row is 'A', the line will be '\tA' not '\tA\t\t\t\t'
sub worksheet2text {

  my $sheet = shift;
  my $last_row = lastrow($sheet);
  
  my @lines = ();
  my $line;
  for my $row ( 0 .. $last_row ) {    
    $line = '';
   
    # empty rows are 'undef'
    if (defined $sheet->{Cells}[$row]) {
      # empty cells are either 'undef' or 'empty slot'
      $line = join ("\t", map { ref $_ ? $_->Value : '' } @{ $sheet->{Cells}[$row] } );
    }
    
    $line .= "\n";
    push @lines, $line;
  }

  return wantarray ? @lines : join ('', @lines);
}


# outputs empty rows as a new line (not multiple tabs).
# this method *does* fill in empty cells with \t since it is based on MaxCol
sub outputfile_worksheet {

  my $sheet = shift;

  # empty worksheets have undef for MaxCol and MaxRow
  my $last_col = lastcol($sheet);
  my $last_row = lastrow($sheet);
  
  #print "MaxCol = $last_col", $/, "MaxRow = $last_row\n";
        
  my $filename = "temp_Paul";
  open (OUTFILE, ">", $filename) or die "Can't open $filename for writing: $!\n";
        
  for my $row ( 0 .. $last_row ) {
    for my $col ( 0 .. $last_col ) {
    
      # empty rows are 'undef'
      if (defined $sheet->{Cells}[$row]) {
        my $cell = $sheet->{Cells}[$row][$col];
        print OUTFILE ref $cell ? $cell->Value : '';
        print OUTFILE "\t" unless $col == $last_col;
      } else {
        last;
      }
    }
    
    print OUTFILE $/; 
  }
  
  close (OUTFILE);
  
  return $filename
}
