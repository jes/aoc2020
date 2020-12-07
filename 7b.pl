#!/usr/bin/perl

use strict;
use warnings;

my $n = 0;

my %contains;

while (<>) {
    chomp;

    if (/^(\w+) (\w+) bags contain (.*)\.$/) {
        my ($property, $colour) = ($1, $2);
        if ($3 ne "no other bags") {
            my @contains = split /, /, $3;
            for my $c (@contains) {
                if ($c =~ /^(\d+) (\w+) (\w+) bags?$/) {
                    my ($innum, $inproperty, $incolour) = ($1, $2, $3);
                    push @{$contains{"$property $colour"}}, {
                        type => "$inproperty $incolour",
                        count => $innum,
                    };
                } else {
                    print "bad contain: $c ($_)\n";
                }
            }
        }
    } else {
        print "bad: $_\n";
    }
}

print count("shiny gold")-1, "\n";

sub count {
    my ($search) = @_;

    my $n = 1;

    for my $c (@{ $contains{$search} }) {
        $n += $c->{count} * count($c->{type});
    }

    return $n;
}
