#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(max);

my $n = 0;

chomp(my @joltages = <>);

my $max = max(@joltages);

my %dp;
$dp{$max+3} = 1;
for my $j (sort { $b <=> $a } (0, @joltages)) {
    $dp{$j} = ($dp{$j+1}||0) + ($dp{$j+2}||0) + ($dp{$j+3}||0);
}

print $dp{0}, "\n";
