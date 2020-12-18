#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum);

my $n = 0;

while (<>) {
    chomp;

    while (/(\([^\(\)]+\))/g) {
        my $subexpr = $1;
        my $r = evaluate($subexpr);
        $_ =~ s/\Q$subexpr\E/$r/g;
    }

    $n += evaluate($_);
}

print "$n\n";

sub evaluate {
    my ($expr) = @_;

    $expr =~ s/[\(\)]//g;

    my @parts = split /\s+/, $expr;

    my $r = $parts[0];

    for (my $i = 2; $i < @parts; $i += 2) {
        $r = eval("$r $parts[$i-1] $parts[$i]");
    }

    return $r;
}
