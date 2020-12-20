#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum product all any uniq);

my $n = 0;

my ($maxx,$maxy);
my %tile;
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

    $tile{$tileid} = \%map;
}

my %edgeincommon;
for my $edge (keys %haveedge) {
    for my $t1 (@{ $haveedge{$edge} }) {
        for my $t2 (@{ $haveedge{$edge} }) {
            $edgeincommon{$t1}{$t2} = 1;
        }
    }
}

my %numcommonedges;
for my $t (keys %edgeincommon) {
    $numcommonedges{$t} = scalar keys %{ $edgeincommon{$t} };
}

my %puzzle;
my %usedtile;

my @answers;
dfs(0,0);

# the answer is the one from the image orientation that produces the fewest squares that
# are not part of a seamonster (i.e. the one that has the most seamonsters)
print min(@answers), "\n";

sub dfs {
    my ($x, $y) = @_;

    no warnings 'recursion';

    if ($x == 12) {
        $x = 0;
        $y++;
    }

    if ($y == 12) {
        push @answers, count_nonmonster_hashes(form_image());
        return;
    }

    my $wantcommonedges = 5 - ($x == 0 || $x == 11) - ($y == 0 || $y == 11);

    my @candidates = keys %tile;

    if ($x != 0) {
        my $xm1 = $x-1;
        @candidates = keys %{ $edgeincommon{$puzzle{"$y,$xm1"}{tile}} };
    }

    for my $t (@candidates) {
        next if $usedtile{$t};
        next if $numcommonedges{$t} != $wantcommonedges;

        $usedtile{$t} = 1;
        for my $o (0..7) {
            if (canfit($t, $o, $x, $y)) {
                $puzzle{"$y,$x"} = {
                    tile => $t,
                    orientation => $o,
                };
                dfs($x+1,$y);
            }
        }
        $usedtile{$t} = 0;
    }
}

# check tile above and tile left
sub canfit {
    my ($tileid, $orientation, $x, $y) = @_;

    if ($x != 0) {
        my $otherx = $x-1;
        my $othertileid = $puzzle{"$y,$otherx"}{tile};
        my $otherorientation = $puzzle{"$y,$otherx"}{orientation};
        for my $i (0..$maxy) {
            return 0 if get_pixel($othertileid,$otherorientation,$maxy,$i) ne get_pixel($tileid,$orientation,0,$i);
        }
    }

    if ($y != 0) {
        my $othery = $y-1;
        my $othertileid = $puzzle{"$othery,$x"}{tile};
        my $otherorientation = $puzzle{"$othery,$x"}{orientation};
        for my $i (0..$maxy) {
            return 0 if get_pixel($othertileid,$otherorientation,$i,$maxy) ne get_pixel($tileid,$orientation,$i,0);
        }
    }

    return 1;
}

sub get_pixel {
    my ($tileid, $orientation, $x, $y) = @_;

    # orientations:
    # 0 - default
    # 1 - rot90
    # 2 - rot180
    # 3 - rot270

    # >= 4 - subtract 4 and invert y
    if ($orientation >= 4) {
        $orientation -= 4;
        $y = $maxy-$y;
    }

    ($x,$y) = ($maxy-$y,$x) for (1..$orientation);

    return $tile{$tileid}{"$y,$x"};
}

sub form_image {
    my %image;

    for my $y (0 .. 11) {
        for my $x (0 .. 11) {
            for my $imy (0 .. 7) {
                for my $imx (0 .. 7) {
                    my $py = $y*8 + $imy;
                    my $px = $x*8 + $imx;
                    $image{"$py,$px"} = get_pixel($puzzle{"$y,$x"}{tile}, $puzzle{"$y,$x"}{orientation}, $imx+1, $imy+1);
                }
            }
        }
    }

    return %image;
}

sub count_nonmonster_hashes {
    my (%image) = @_;

    #                   # 
    # #    ##    ##    ###
    #  #  #  #  #  #  #   
    my @xs = (18,0,5,6,11,12,17,18,19,1,4,7,10,13,16);
    my @ys = (0, 1,1,1,1, 1, 1, 1, 1, 2,2,2,2, 2, 2);

    my %ismonster;

    for my $y (0 .. 12*8-1-2) {
        X:
        for my $x (0 .. 12*8-1-18) {
            for my $c (0..14) {
                my $py = $y+$ys[$c];
                my $px = $x+$xs[$c];
                next X if ($image{"$py,$px"} ne '#');
            }
            for my $c (0..14) {
                my $py = $y+$ys[$c];
                my $px = $x+$xs[$c];
                $ismonster{"$py,$px"} = 1;
            }

        }
    }

    my $n = 0;

    for my $y (0 .. 12*8-1) {
        for my $x (0 .. 12*8-1) {
            $n++ if $image{"$y,$x"} eq '#' && !$ismonster{"$y,$x"};
        }
    }

    return $n;
}
