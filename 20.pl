#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum product all any uniq);

my ($maxx,$maxy);
my %haveedge;

while (<>) {
    chomp;
    /^Tile (\d+):$/ or die "bad: $_\n";
    my $tileid = $1;

    my %map;
    my $y = 0;
    while (<>) {
        chomp;

        last if $_ eq '';

        my @c = split //;

        for my $x (0..$#c) {
            $map{"$y,$x"} = $c[$x];
            $maxx = $x;
        }
        $maxy = $y;
        $y++;
    }

    my @edge=('')x4;

    for my $i (0..$maxy) {
        $edge[0] .= $map{"$i,0"};
        $edge[1] .= $map{"$i,$maxy"};
        $edge[2] .= $map{"0,$i"};
        $edge[3] .= $map{"$maxy,$i"};
    }

    push @{ $haveedge{$_} }, $tileid for @edge;
    push @{ $haveedge{reverse $_} }, $tileid for @edge;
}

my %edgeincommon;
for my $edge (keys %haveedge) {
    for my $t1 (@{ $haveedge{$edge} }) {
        for my $t2 (@{ $haveedge{$edge} }) {
            $edgeincommon{$t1}{$t2} = 1;
        }
    }
}

my $r = 1;

for my $t (keys %edgeincommon) {
    my $n = scalar keys %{ $edgeincommon{$t} };
    $r *= $t if $n == 3;
}

print "$r\n";
