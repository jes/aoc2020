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

    my @multiply = ($parts[0]);

    # addition
    for (my $i = 2; $i < @parts; $i += 2) {
        if ($parts[$i-1] eq '+') {
            my $r = eval("$multiply[$#multiply] $parts[$i-1] $parts[$i]");
            pop @multiply;
            push @multiply, $r;
        } else {
            push @multiply, $parts[$i];
        }
    }

    return eval(join('*',@multiply));
}
