#!/usr/bin/perl

use strict;
use warnings;

my $n = 0;

my @nums;

while (<>) {
    chomp;
    push @nums, $_;
}

for my $i (25..$#nums) {
    my %got;
    my $ok = 0;
    for my $j (1..25) {
        $got{$nums[$i-$j]} = 1;

        my $need = $nums[$i]-$nums[$i-$j];
        $ok = 1 if $got{$need};
    }
    if (!$ok) {
        print "$nums[$i]\n";
        exit;
    }
}
