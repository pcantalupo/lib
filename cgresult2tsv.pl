#!/usr/bin/perl env
use strict;
use warnings;
use cghub;

# parse cgquery text output into 1 row per result with fields separated by tabs
cgresult2tsv(join ('', <>));

