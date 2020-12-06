#!/usr/bin/perl

use strict;
use warnings;

my %s;
my $nppl = 0;

my $n = 0;

while (<>) {
    chomp;

    if ($_ eq '') {
        my $myn = 0;
        for my $k (keys %s) {
            $myn++ if $s{$k}==$nppl;
        }
        $n += $myn;
        %s = ();
        $nppl = -1;
    }

    for my $c (split //) {
        $s{$c}++ if ($s{$c}||0) == $nppl;
    }   

    $nppl++;
}

print "$n\n";
