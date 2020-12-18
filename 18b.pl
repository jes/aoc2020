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

    my @parts2 = ($parts[0]);

    # addition
    for (my $i = 2; $i < @parts; $i += 2) {
        if ($parts[$i-1] eq '+') {
            my $r = eval("$parts2[$#parts2] $parts[$i-1] $parts[$i]");
            pop @parts2;
            push @parts2, $r;
        } else {
            push @parts2, $parts[$i-1], $parts[$i];
        }
    }

    my $r = $parts2[0];

    # multiplication
    for (my $i = 2; $i < @parts2; $i += 2) {
        $r = eval("$r $parts2[$i-1] $parts2[$i]");
    }

    return $r;
}
