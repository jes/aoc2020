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

    my @c = split //, $password;

    my $n = ($c[$min-1] eq $letter) + ($c[$max-1] eq $letter);

    return 1 if $n == 1;
}
