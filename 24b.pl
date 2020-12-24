#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum product any all uniq);

my $n = 0;

my %black;

while (<>) {
    chomp;

    my @route;
    while ($_) {
        if ($_ =~ s/^([ew])//) {
            push @route, $1;
        } elsif ($_ =~ s/^([ns][ew])//) {
            push @route, $1;
        } else {
            print "bad: $_\n";
        }
    }

    flip(@route);
}

for (1..100) {
    my %new;
    my %neighbours = count_neighbours(keys %black);

    for my $k (keys %neighbours) {
        my $n = $neighbours{$k};
        if ($black{$k} && ($n == 1 || $n == 2)) {
            $new{$k} = 1;
        } elsif (!$black{$k} && $n == 2) {
            $new{$k} = 1;
        }
    }
    %black = %new;
}

print scalar(keys %black) . "\n";

sub flip {
    my @route = @_;

    my ($x,$y,$z) = (0,0,0);

    for my $dir (@route) {
        ($x,$y,$z) = step($x,$y,$z,$dir);
    }

    if ($black{"$x,$y,$z"}) {
        delete $black{"$x,$y,$z"};
    } else {
        $black{"$x,$y,$z"} = 1;
    }
}

sub count_neighbours {
    my (@in) = @_;

    my %neighs;

    for my $p (@in) {
        $neighs{$p} ||= 0;
        for my $dir (qw(e w sw ne se nw)) {
            my ($x,$y,$z) = step(split(/,/, $p), $dir);
            $neighs{"$x,$y,$z"}++;
        }
    }

    return %neighs;
}

sub step {
    my ($x,$y,$z,$dir) = @_;

    # https://www.redblobgames.com/grids/hexagons/
    if ($dir eq 'e') {
        $x += 1; $z -= 1;
    } elsif ($dir eq 'w') {
        $x -= 1; $z += 1;
    } elsif ($dir eq 'sw') {
        $x -= 1; $y += 1;
    } elsif ($dir eq 'ne') {
        $x += 1; $y -= 1;
    } elsif ($dir eq 'se') {
        $z -= 1; $y += 1;
    } elsif ($dir eq 'nw') {
        $z += 1; $y -= 1;
    } else {
        print "bad dir: $_\n";
    }

    return ($x,$y,$z);
}
