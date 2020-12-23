#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum product any all uniq);

my $n = 0;

my $input = <>;
chomp $input;

# clockwise = +ve
my @cups = split //, $input;

my $maxcup = max @cups;

for (1..100) {
    my @threecups = @cups[1..3];
    splice @cups, 1, 3;

    my $find = $cups[0];

    do {
        $find--;
        $find = $maxcup if $find == 0;
    } while (any {$_ eq $find} @threecups);

    my $idx = 0;
    for my $i (0..$#cups) {
        $idx = $i if $cups[$i] == $find;
    }

    splice @cups, $idx+1, 0, @threecups;

    push @cups, shift @cups;
}

while ($cups[0] != 1) {
    push @cups, shift @cups;
}

shift @cups;
print join('', @cups), "\n";
