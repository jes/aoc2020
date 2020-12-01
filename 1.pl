#!/usr/bin/perl

use strict;
use warnings;

my %got;

while (<>) {
    chomp;
    $_=int($_);
    $got{$_} = 1;
    if ($got{2020-$_}) {
        print $_ * (2020-$_), "\n";
    }
}
