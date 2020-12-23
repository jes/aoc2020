#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum product any all uniq first);

my $n = 0;

my $input = <>;
chomp $input;

# clockwise = +ve
my @cups = map { +{v => $_, next => undef} } split //, $input;

my $first = $cups[0];
my $last;
for my $i (0..$#cups-1) {
    $cups[$i]->{next} = $cups[$i+1];
}

my $maxcup = max map { $_->{v} } @cups;

$last = $cups[$#cups];

my %cup;

while ($maxcup < 1_000_000) {
    my $new = {
        v => ++$maxcup,
        next => undef,
    };
    $last->{next} = $new;
    $last = $new;
}

my $p = $first;
while ($p) {
    $cup{$p->{v}} = $p;
    $p = $p->{next};
}

my %seen;

for my $step (1..10_000_000) {
    my $threecups = $first->{next};
    $first->{next} = $first->{next}{next}{next}{next};
    $threecups->{next}{next}{next} = undef;

    my @threevalues = ($threecups->{v}, $threecups->{next}{v}, $threecups->{next}{next}{v});

    my $find = $first->{v};

    do {
        $find--;
        $find = $maxcup if $find == 0;
    } while (any {$_ eq $find} @threevalues);

    $p = $cup{$find};

    my $n = $p->{next};
    $p->{next} = $threecups;
    $threecups->{next}{next}{next} = $n;

    $last = $last->{next} while ($last->{next});

    my $cur = $first;
    $last->{next} = $cur;
    $last = $cur;
    $first = $cur->{next};
    $cur->{next} = undef;
}

$p = $cup{1};
print "" . ($p->{next}{v} * $p->{next}{next}{v}) . "\n";
