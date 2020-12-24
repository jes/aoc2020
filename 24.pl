#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum product any all uniq);

my $n = 0;

my %flipped;

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

print scalar(grep {$_%2==1} values %flipped), "\n";

sub flip {
    my @route = @_;

    my ($x,$y,$z) = (0,0,0);

    for my $dir (@route) {
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
    }

    $flipped{"$x,$y,$z"}++;
}
