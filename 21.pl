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

for my $ingredient (keys %seen_ingredient) {
    my $ok = 1;
    for my $allergen (keys %seen_allergen) {
        $ok = 0 if $mightcontain{$allergen}{$ingredient};
    }
    $n += $timesseen{$ingredient} if $ok;
}

print "$n\n";
