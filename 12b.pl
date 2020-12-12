#!/usr/bin/perl

use strict;
use warnings;

my $x = 0;
my $y = 0;

my $wayx = 10;
my $wayy = -1;

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
            $wayx += $compass{$cmd}[0] * $dist;
            $wayy += $compass{$cmd}[1] * $dist;
        } elsif ($cmd eq 'R') {
            for (1..$dist/90) {
                my $oldy = $wayy;
                $wayy = $wayx;
                $wayx = -$oldy;
            }
        } elsif ($cmd eq 'L') {
            for (1..$dist/90) {
                my $oldy = $wayy;
                $wayy = -$wayx;
                $wayx = $oldy;
            }
        } elsif ($cmd eq 'F') {
            $x += $wayx * $dist;
            $y += $wayy * $dist;
        }
    } else {
        print "bad: $_\n";
    }
}

print abs($x)+abs($y), "\n";
