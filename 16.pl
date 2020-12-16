#!/usr/bin/perl

use strict;
use warnings;

my %fields;

while (<>) {
    chomp;
    last if !$_;

    if (/^([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)$/) {
        my ($field, $a,$b,$c,$d) = ($1, $2, $3, $4, $5);
        $fields{$field} = [$a,$b,$c,$d];
    } else {
        print "bad: $_\n";
    }
}

chomp(my $l = <>);
print "bad: $l\n" unless $l eq 'your ticket:';

chomp(my $myticket = split /,/, <>);

<>;

chomp($l = <>);
print "bad: $l\n" unless $l eq 'nearby tickets:';

my @tickets;

while (<>) {
    chomp;
    my @nums = split /,/;
    push @tickets, \@nums;
}

my $err = 0;

for my $t (@tickets) {
    for my $n (@$t) {
        my $valid = 0;
        for my $f (keys %fields) {
            my ($a, $b, $c, $d) = @{ $fields{$f} };
            $valid = 1 if ($a <= $n && $b >= $n) || ($c <= $n && $d >= $n);
        }
        $err += $n if !$valid;
    }
}

print "$err\n";
