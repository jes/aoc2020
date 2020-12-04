#!/usr/bin/perl

use strict;
use warnings;

my $nvalid = 0;

my %f;

while (<>) {
    chomp;

    if ($_ eq '') {
        $nvalid++ if validate();
        %f = ();
        next;
    }

    my (@fields) = split / /;

    for my $f (@fields) {
        my ($k,$v) = split /:/, $f;
        $f{$k} = $v;
    }
}

$nvalid++ if validate();

print "$nvalid\n";

sub validate {
    delete $f{cid};
    return 0 unless join('',sort(keys %f)) eq join('',sort(qw(byr iyr eyr hgt hcl ecl pid)));
}
