#!/usr/bin/perl

use strict;
use warnings;

my $n = 0;

my ($maxx,$maxy);
my %map;

my $y = 0;
while (<>) {
    chomp;

    my @c = split //;

    for my $x (0..$#c) {
        $map{"$y,$x"} = $c[$x];
        $maxx = $x;
    }
    $maxy = $y;
    $y++;
}

while (1) {
    %map = iterate(%map);
    printmap(%map);
    print num_occupied(%map), "\n";
}

sub num_occupied {
    my (%map) = @_;

    my $n = 0;

    for my $c (keys %map) {
        $n++ if $map{$c} eq '#';
    }

    return $n;
}

sub iterate {
    my (%map) = @_;

    my %new = %map;

    for my $y (0 .. $maxy) {
        for my $x (0 .. $maxx) {
            my $adj = adjacent_occupied(\%map, $x,$y);
            if ($map{"$y,$x"} eq 'L' && $adj == 0) {
                $new{"$y,$x"} = '#';
            } elsif ($map{"$y,$x"} eq '#' && $adj >= 4) {
                $new{"$y,$x"} = 'L';
            }
        }
    }

    return %new;
}

sub adjacent_occupied {
    my ($map, $x, $y) = @_;

    my @dx = (-1, 0, 1, 0, -1, -1, 1, 1);
    my @dy = (0, -1, 0, 1, -1, 1, -1, 1);

    my $n = 0;

    for my $i (0..$#dx) {
        my $nx = $x+$dx[$i];
        my $ny = $y+$dy[$i];
        $n++ if ($map->{"$ny,$nx"}||'') eq '#';
    }

    return $n;
}

sub printmap {
    my (%map) = @_;

    for my $y (0 .. $maxy) {
        for my $x (0 .. $maxx) {
            print $map{"$y,$x"};
        }
        print "\n";
    }
}
