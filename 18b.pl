#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(product);

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

    my @multiply = ($parts[0]);

    # addition
    for (my $i = 2; $i < @parts; $i += 2) {
        if ($parts[$i-1] eq '+') {
            my $last = pop @multiply;
            my $r = $last + $parts[$i];
            push @multiply, $r;
        } else {
            push @multiply, $parts[$i];
        }
    }

    return product(@multiply);
}
