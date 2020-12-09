#!/usr/bin/perl

use strict;
use warnings;

my $n = 0;

my @nums;

while (<>) {
    chomp;
    push @nums, $_;
}

my $start = 0;
my $end = 0;
my $sum = $nums[0];
my $target = 756008079;

while (1) {
    if ($sum > $target) {
        $sum -= $nums[$start];
        $start++;
    } elsif ($sum < $target) {
        $end++;
        $sum += $nums[$end];
    } else {
        my ($min,$max);
        for my $i ($start..$end) {
            $min = $nums[$i] if !defined $min || $nums[$i] < $min;
            $max = $nums[$i] if !defined $max || $nums[$i] > $max;
        }
        print "" . ($min+$max) . "\n";
        exit;
    }
}
