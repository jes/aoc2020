#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum);

my $n = 0;

my ($maxx,$maxy,$maxz,$maxw) = (0,0,0,0);
my ($minx,$miny,$minz,$minw) = (0,0,0,0);
my %map;

my $y = 0;
while (<>) {
    chomp;

    my @c = split //;

    for my $x (0..$#c) {
        $map{"0,0,$y,$x"} = $c[$x];
        $maxx = $x;
    }
    $maxy = $y;
    $y++;
}

for (1..6) {
    my %newmap = %map;

    $minx--; $miny--; $minz--; $minw--;
    $maxx++; $maxy++; $maxz++; $maxw++;

    #print "\n\n\n\n";
    for my $w ($minw .. $maxw) {
    for my $z ($minz .. $maxz) {
        #print "z=$z:\n";
        for my $y ($miny .. $maxy) {
            for my $x ($minx .. $maxx) {
                $map{"$w,$z,$y,$x"} ||= '.';
                #print $map{"$z,$y,$x"};
                my $n = neighs(\%map, $x,$y,$z,$w);
                if ($map{"$w,$z,$y,$x"} eq '#' && ($n < 2 || $n > 3)) {
                    $newmap{"$w,$z,$y,$x"} = '.';
                } elsif ($map{"$w,$z,$y,$x"} eq '.' && ($n == 3)) {
                    $newmap{"$w,$z,$y,$x"} = '#';
                }
            }
            #print "\n";
        }
    }
    }
    %map = %newmap;
}

print sum(map { $_ eq '#' ? 1 : 0 } values %map), "\n";

sub neighs {
    my ($map, $x,$y,$z,$w) = @_;

    my $n = 0;

    for my $dw (-1..1) {
    for my $dz (-1..1) {
    for my $dy (-1..1) {
    for my $dx (-1..1) {
        next if $dx==0 && $dy==0 && $dz == 0 && $dw == 0;
        my $nx = $x+$dx;
        my $ny = $y+$dy;
        my $nz = $z+$dz;
        my $nw = $w+$dw;
        $n++ if ($map->{"$nw,$nz,$ny,$nx"}||'.') eq '#';
    }
    }
    }
    }

    return $n;
}
