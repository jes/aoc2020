#!/usr/bin/perl

use strict;
use warnings;

my %s;

my $n = 0;

while (<>) {
    chomp;

    if ($_ eq '') {
        $n += scalar keys %s;
        %s = ();
    }

    for my $c (split //) {
        $s{$c}++;
    }   
}

print "$n\n";
