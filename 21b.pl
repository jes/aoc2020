#!/usr/bin/perl

use strict;
use warnings;

my $n = 0;

my %mightcontain;
my %seen_allergen;
my %seen_ingredient;
my %timesseen;

while (<>) {
    chomp;

    if (/^(.*) \(contains (.*)\)$/) {
        my @ingredients = split / /, $1;
        my @allergens = split /, /, $2;

        my %have_ingredient = map { $_ => 1 } @ingredients;
        my %have_allergen = map { $_ => 1 } @allergens;

        for my $i (@ingredients) {
            next if $seen_ingredient{$i};
            $mightcontain{$_}{$i} = 0 for keys %seen_allergen;
        }

        for my $a (@allergens) {
            if (exists $mightcontain{$a}) {
                for my $maybeingredient (keys %seen_ingredient) {
                    $mightcontain{$a}{$maybeingredient} = 0 if !$have_ingredient{$maybeingredient};
                }
            }
            for my $i (@ingredients) {
                $mightcontain{$a}{$i} = 1 if !exists $mightcontain{$a}{$i};

                $mightcontain{$a}{$i} = 0 if ($seen_allergen{$a} && !$seen_ingredient{$i});
            }
        }

        $seen_ingredient{$_} = 1 for @ingredients;
        $seen_allergen{$_} = 1 for @allergens;

        $timesseen{$_}++ for @ingredients;
    } else {
        print "bad: $_\n";
    }
}

my %allergen_is;
my $madechanges;

do {
    $madechanges = 0;
    for my $a (keys %seen_allergen) {
        my $npossible = 0;
        my $possible;
        for my $i (keys %seen_ingredient) {
            if ($mightcontain{$a}{$i}) {
                $npossible++;
                $possible = $i;
            }
        }

        if ($npossible == 1) {
            $allergen_is{$a} = $possible;
            for my $othera (keys %seen_allergen) {
                next if $a eq $othera;
                if ($mightcontain{$othera}{$possible}) {
                    $mightcontain{$othera}{$possible} = 0;
                    $madechanges = 1;
                }
            }
        }
    }
} while ($madechanges);

print join(',', map { $allergen_is{$_} } sort keys %allergen_is), "\n";
