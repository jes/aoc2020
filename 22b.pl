#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum product any all uniq);

my $n = 0;

# bottom at index 0
my @p1;
my @p2;

my $arr;

while (<>) {
    chomp;

    next if $_ eq '';
    if ($_ eq 'Player 1:') {
        $arr = \@p1;
    } elsif ($_ eq 'Player 2:') {
        $arr = \@p2;
    } else {
        unshift @$arr, $_;
    }
}

game(\@p1, \@p2);

$arr = @p1 ? \@p1 : \@p2;

for my $i (0 .. @$arr-1) {
    $n += $arr->[$i] * ($i + 1);
}

print "$n\n";

sub game {
    my ($p1, $p2) = @_;

    my %seen;

    while (@$p1 && @$p2) {
        my $k = join(',', @$p1) . ':' . join(',', @$p2);
        if ($seen{$k}++) {
            # XXX: ?
            $p1 = [1,2,3];
            $p2 = [];
            return;
        }

        my $c1 = pop @$p1;
        my $c2 = pop @$p2;

        if (@$p1 >= $c1 && @$p2 >= $c2) {
            my @new_p1 = reverse @$p1;
            @new_p1 = reverse @new_p1[0..$c1-1];
            my @new_p2 = reverse @$p2;
            @new_p2 = reverse @new_p2[0..$c2-1];
            game(\@new_p1, \@new_p2);

            if (@new_p1) {
                unshift @$p1, $c2, $c1;
            } else {
                unshift @$p2, $c1, $c2;
            }
        } else {
            if ($c1 > $c2) {
                unshift @$p1, $c2, $c1;
            } else {
                unshift @$p2, $c1, $c2;
            }
        }
    }

    return;
}
