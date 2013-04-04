#!/opt/sam/perl/5.16.2/gcc45/bin/perl -w
use strict;
use cghub;

# parse cgquery text output into 1 row per result with fields separated by tabs
cgresult2tsv(join ('', <>));

