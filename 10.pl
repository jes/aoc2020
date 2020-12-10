#!/usr/bin/perl

use strict;
use warnings;

chomp(my @joltages = <>);
@joltages = sort { $a <=> $b } (0, @joltages);

my ($ones,$threes) = (0,1);

for my $i (1..$#joltages) {
    my $d = $joltages[$i] - $joltages[$i-1];
    $ones++ if $d==1;
    $threes++ if $d==3;
}

print "" . ($ones*$threes) . "\n";
