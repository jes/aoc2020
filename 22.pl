#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum product any all uniq);

my $n = 0;

# bottom at index 0
my @p1;
my @p2;

my $arr;

while (<>) {
    chomp;

    next if $_ eq '';
    if ($_ eq 'Player 1:') {
        $arr = \@p1;
    } elsif ($_ eq 'Player 2:') {
        $arr = \@p2;
    } else {
        unshift @$arr, $_;
    }
}

while (@p1 && @p2) {
    my $c1 = pop @p1;
    my $c2 = pop @p2;

    if ($c1 > $c2) {
        unshift @p1, $c2, $c1;
    } else {
        unshift @p2, $c1, $c2;
    }
}

$arr = @p1 ? \@p1 : \@p2;

for my $i (0 .. @$arr-1) {
    $n += $arr->[$i] * ($i + 1);
}

print "$n\n";
