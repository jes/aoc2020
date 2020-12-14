#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max);

my $n = 0;

my %mem;
my $mask = '0'x36;

while (<>) {
    chomp;

    if (/^mem\[(\d+)\] = (\d+)$/) {
        my ($addr, $val) = ($1, $2);
        $mem{$addr} = permute($val, $mask);
    } elsif (/^mask = (\w+)$/) {
        $mask = $1;
    } else {
        print "bad: $_\n";
    }
}

for my $k (keys %mem) {
    $n += $mem{$k};
}

print "$n\n";

sub permute {
    my ($val, $mask) = @_;

    my @bits = split //, reverse $mask;
    for my $i (0..35) {
        next if $bits[$i] eq 'X';
        if ($bits[$i] == 1) {
            $val |= (1 << $i);
        } else {
            $val &= ~(1 << $i);
        }
    }

    return $val;
}
