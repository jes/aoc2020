#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(sum product min max any all uniq);

my $n = 0;

my $n1 = <>;
chomp $n1;
my $n2 = <>;
chomp $n2;

my $ls1 = find_loopsize($n1);
my $ls2 = find_loopsize($n2);

print transform($n1, $ls2), "\n";
print transform($n2, $ls1), "\n";

sub transform {
    my ($init, $loopsize) = @_;

    my $subject = $init;
    my $value = 1;

    for (1..$loopsize) {
        $value = ($value * $subject)%20201227;
    }

    return $value;
}

sub find_loopsize {
    my ($n) = @_;

    my $ls = 0;

    my $subject = 7;
    my $value = 1;

    while ($value != $n) {
        $value = ($value * $subject)%20201227;
        $ls++;
    }

    return $ls;
}
