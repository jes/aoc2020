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

my $trees = 1;

my @xstep = (1,3,5,7,1);
my @ystep = (1,1,1,1,2);

for my $i (0..$#xstep) {

    my $thesetrees = 0;

    my $x = 0;
    for my $y (0..$maxy) {
        next if $ystep[$i]==2 && $y%2 == 1; # lol
        $x = $x % ($maxx+1);
        $thesetrees++ if $map{"$y,$x"} eq '#';
        $x += $xstep[$i];
    }

    $trees *= $thesetrees;
}

print "$trees\n";
