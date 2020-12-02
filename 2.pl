#!/usr/bin/perl

use strict;
use warnings;

my $nvalid = 0;

while (<>) {
    chomp;

    if (/^(\d+)-(\d+) (\w): (.*)$/) {
        my ($mincount, $maxcount, $letter, $password) = ($1, $2, $3, $4);
        $nvalid++ if valid($mincount, $maxcount, $letter, $password);
    } else {
        print STDERR "bad: $_\n";
    }
}

print "$nvalid\n";

sub valid {
    my ($min, $max, $letter, $password) = @_;

    my %count;

    my @c = split //, $password;
    $count{$_}++ for split //, $password;

    $count{$letter} ||= 0;

    return 1 if $count{$letter} >= $min && $count{$letter} <= $max;
}
