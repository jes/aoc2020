#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(max);

my $n = 0;

my %got = (0 => 1);

chomp(my @joltages = <>);
$got{$_} = 1 for @joltages;

my $max = max(@joltages);
$got{$max+3} = 1;

my %jescache;

print dfs(0), "\n";

sub dfs {
    my ($j) = @_;

    no warnings 'recursion';

    return 1 if $j == $max+3;
    return 0 if !$got{$j};

    if (!$jescache{$j}) {
        my $n = dfs($j+1) + dfs($j+2) + dfs($j+3);
        %jescache = () if keys %jescache > 100000;
        $jescache{$j} = $n;
    }

    return $jescache{$j};
}
