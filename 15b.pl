#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max);

chomp(my @nums = split /,/, <>);

my %said;

$said{$nums[$_]} = [0,$_,1] for (0..$#nums);

my $last = $nums[$#nums];

for my $i (@nums..29999999) {
    my ($prevspoken, $lastspoken, $timesspoken) = @{ $said{$last} };
    my $num;
    if ($timesspoken == 1) {
        $num = 0;
    } else {
        $num = $lastspoken-$prevspoken;
    }

    ($prevspoken, $lastspoken, $timesspoken) = @{ $said{$num}||[0,0,0] };
    $said{$num} = [$lastspoken, $i,$timesspoken+1];
    $last = $num;
}

print $last, "\n";
