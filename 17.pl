#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum);

my $n = 0;

my ($maxx,$maxy,$maxz) = (0,0,0);
my ($minx,$miny,$minz) = (0,0,0);
my %map;

my $y = 0;
while (<>) {
    chomp;

    my @c = split //;

    for my $x (0..$#c) {
        $map{"0,$y,$x"} = $c[$x];
        $maxx = $x;
    }
    $maxy = $y;
    $y++;
}

for (1..6) {
    my %newmap = %map;

    $minx--; $miny--; $minz--;
    $maxx++; $maxy++; $maxz++;

    print "\n\n\n\n";
    for my $z ($minz .. $maxz) {
        print "z=$z:\n";
        for my $y ($miny .. $maxy) {
            for my $x ($minx .. $maxx) {
                $map{"$z,$y,$x"} ||= '.';
                print $map{"$z,$y,$x"};
                my $n = neighs(\%map, $x,$y,$z);
                if ($map{"$z,$y,$x"} eq '#' && ($n < 2 || $n > 3)) {
                    $newmap{"$z,$y,$x"} = '.';
                } elsif ($map{"$z,$y,$x"} eq '.' && ($n == 3)) {
                    $newmap{"$z,$y,$x"} = '#';
                }
            }
            print "\n";
        }
    }
    %map = %newmap;
}

print sum(map { $_ eq '#' ? 1 : 0 } values %map), "\n";

sub neighs {
    my ($map, $x,$y,$z) = @_;

    my $n = 0;

    for my $dz (-1..1) {
    for my $dy (-1..1) {
    for my $dx (-1..1) {
        next if $dx==0 && $dy==0 && $dz == 0;
        my $nx = $x+$dx;
        my $ny = $y+$dy;
        my $nz = $z+$dz;
        $n++ if ($map->{"$nz,$ny,$nx"}||'.') eq '#';
    }
    }
    }

    return $n;
}
