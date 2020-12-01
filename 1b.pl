#!/usr/bin/perl

use strict;
use warnings;

my %got;

while (<>) {
    chomp;
    $_=int($_);
    $got{$_} = 1;
}

for my $a (keys %got) {
    for my $b (keys %got) {
        my $c = 2020-($a+$b);
        if ($got{$c}) {
            print $a*$b*$c, "\n";
        }
    }
}
