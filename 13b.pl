#!/usr/bin/perl

use strict;
use warnings;

my $earliest = <>;
chomp $earliest;

my $bus_ids_s = <>;
chomp $bus_ids_s;

my @busids = split /,/, $bus_ids_s;

print "Please solve the following using Chinese Remainder Theorem:\n";

for my $b (0..$#busids) {
    next if $busids[$b] eq 'x';
    print "x = $b mod $busids[$b]\n";
}

print "Please input your solution:\n";

my $t = <>;
chomp $t;

my $ok = 1;
for my $j (0..$#busids) {
    next if $busids[$j] eq 'x';
    if (($t+$j)%$busids[$j] != 0) {
        $ok = 0;
        print "Bad: ($t+$j)%$busids[$j] == " . (($t+$j)%$busids[$j]) . "\n";
    }
}
print "Looks good!\n" if $ok;

__END__

my $idxlargest = 0;
my $largest = 0;
for my $b (0..$#busids) {
    next if $busids[$b] eq 'x';
    if ($busids[$b] > $largest) {
        $largest = $busids[$b];
        $idxlargest = $b;
    }
}

for (my $i = -$idxlargest; 1; $i += $largest) {
    my $ok = 1;
    for my $j (0..$#busids) {
        next if $busids[$j] eq 'x';
        $ok = 0 if ($i+$j)%$busids[$j] != 0;
    }
    if ($ok) {
        print "$i\n";
        exit;
    }
}
