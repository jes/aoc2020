#!/usr/bin/perl

use strict;
use warnings;

my $x = 0;
my $y = 0;
my $d = 0;

#         E  S   W  N
my @dx = (1, 0, -1, 0);
my @dy = (0, 1, 0, -1);

my %compass = (
    N => [0,-1],
    S => [0,1],
    E => [1,0],
    W => [-1,0],
);

while (<>) {
    chomp;
    if (/^([NSEWLRF])(\d+)$/) {
        my ($cmd, $dist) = ($1, $2);


        if ($cmd =~ /[NSEW]/) {
            $x += $compass{$cmd}[0] * $dist;
            $y += $compass{$cmd}[1] * $dist;
        } elsif ($cmd eq 'L') {
            $d = ($d+3) % 4 for (1..$dist/90);
        } elsif ($cmd eq 'R') {
            $d = ($d+1) % 4 for (1..$dist/90);
        } elsif ($cmd eq 'F') {
            $x += $dx[$d] * $dist;
            $y += $dy[$d] * $dist;
        }

    } else {
        print "bad: $_\n";
    }
}

print abs($x)+abs($y), "\n";
