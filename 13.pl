#!/usr/bin/perl

use strict;
use warnings;

my $earliest = <>;
chomp $earliest;

my $bus_ids_s = <>;
chomp $bus_ids_s;

my @busids = grep { $_ ne 'x' } split /,/, $bus_ids_s;

for (my $i = $earliest; 1; $i++) {
    for my $b (@busids) {
        if ($i%$b == 0) {
            print "$i,$b\n";
            print "" . ($i-$earliest)*$b, "\n";
            exit;
        }
    }
}
