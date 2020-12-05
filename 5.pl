#!/usr/bin/perl

use strict;
use warnings;

my $max = 0;

while (<>) {
    chomp;
    s/F/0/g;
    s/B/1/g;
    s/R/1/g;
    s/L/0/g;
    my $num = oct("0b" . $_);

    $max = $num if $num > $max;
}

print "$max\n";
