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

    return 0 if $f{byr} < 1920 || $f{byr} > 2002;
    return 0 if $f{iyr} < 2010 || $f{iyr} > 2020;
    return 0 if $f{eyr} < 2020 || $f{eyr} > 2030;
    if ($f{hgt} =~ /^(\d+)cm$/) {
        return 0 if $1 < 150 || $1 > 193;
    } elsif ($f{hgt} =~ /^(\d+)in$/) {
        return 0 if $1 < 59 || $1 > 76;
    } else {
        return 0;
    }
    return 0 unless $f{hcl} =~ /^#[0-9a-f]{6}$/;
    return 0 unless $f{ecl} =~ /^(amb|blu|brn|gry|grn|hzl|oth)$/;
    return 0 unless $f{pid} =~ /^[0-9]{9}$/;
    return 1;
}
