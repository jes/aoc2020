#!/usr/bin/perl

use strict;
use warnings;

my $n = 0;

my %containedby;
my %counted;

while (<>) {
    chomp;

    if (/^(\w+) (\w+) bags contain (.*)\.$/) {
        my ($property, $colour) = ($1, $2);
        if ($3 ne "no other bags") {
            my @contains = split /, /, $3;
            for my $c (@contains) {
                if ($c =~ /^(\d+) (\w+) (\w+) bags?$/) {
                    my ($innum, $inproperty, $incolour) = ($1, $2, $3);
                    push @{$containedby{"$inproperty $incolour"}}, "$property $colour";
                } else {
                    print "bad contain: $c ($_)\n";
                }
            }
        }
    } else {
        print "bad: $_\n";
    }
}

count("shiny gold");
print "$n\n";

sub count {
    my ($search) = @_;

    for my $c (@{ $containedby{$search} }) {
        if (!$counted{$c}) {
            $counted{$c} = 1;
            $n++;
            count($c);
        }
    }
}
