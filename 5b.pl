#!/usr/bin/perl

use strict;
use warnings;

my $min = 10000;
my $max = 0;

my %seen;

while (<>) {
    chomp;
    s/F/0/g;
    s/B/1/g;
    s/R/1/g;
    s/L/0/g;
    my $num = oct("0b" . $_);

    $max = $num if $num > $max;
    $min = $num if $num < $min;
    $seen{$num} = 1;
}


for my $i ($min..$max) {
    print "$i\n" if !$seen{$i};
}
