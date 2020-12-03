#!/usr/bin/perl

use strict;
use warnings;

my %map;

my $y = 0;
my ($maxx,$maxy);

while (<>) {
    chomp;
    my @c = split //;
    for my $x (0 .. $#c) {
        $map{"$y,$x"} = $c[$x];
        $maxx = $x;
    }
    $maxy = $y;
    $y++;
}

my $trees = 0;

my $x = 0;
for my $y (0..$maxy) {
    $x = $x % ($maxx+1);
    $trees++ if $map{"$y,$x"} eq '#';
    $x += 3;
}

print "$trees\n";
