#!/usr/bin/perl

use strict;
use warnings;

my %fields;

while (<>) {
    chomp;
    last if !$_;

    if (/^([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)$/) {
        my ($field, $a,$b,$c,$d) = ($1, $2, $3, $4, $5);
        $fields{$field} = [$a,$b,$c,$d];
    } else {
        print "bad: $_\n";
    }
}

chomp(my $l = <>);
print "bad: $l\n" unless $l eq 'your ticket:';

chomp(my @myticket = split /,/, <>);

<>;

chomp($l = <>);
print "bad: $l\n" unless $l eq 'nearby tickets:';

my @tickets;

while (<>) {
    chomp;
    my @nums = split /,/;
    push @tickets, \@nums;
}

my %fieldcanbe;

for my $f (keys %fields) {
    my @f = @{ $tickets[0] };
    $fieldcanbe{$f} = { map { $_ => 1 } (0..$#f) };
}

for my $t (@tickets) {
    my $validticket = 1;
    for my $n (@$t) {
        my $validfield = 0;
        for my $f (keys %fields) {
            my ($a, $b, $c, $d) = @{ $fields{$f} };
            $validfield = 1 if ($a <= $n && $b >= $n) || ($c <= $n && $d >= $n);
        }
        $validticket = 0 if !$validfield;
    }

    if ($validticket) {
        my @ns = @$t;
        for my $i (0..$#ns) {
            my $n = $ns[$i];
            for my $f (keys %fields) {
                my ($a, $b, $c, $d) = @{ $fields{$f} };
                delete $fieldcanbe{$f}{$i} unless ($a <= $n && $b >= $n) || ($c <= $n && $d >= $n);
            }
        }

    }
}

dfs(0, %fieldcanbe);

sub dfs {
    my ($i, %fieldcanbe) = @_;

    if ($i == @myticket) {
        my $n = 1;

        for my $f (keys %fields) {
            if ($f =~ /departure/) {
                my @keys = keys %{ $fieldcanbe{$f} };
                my $id = (keys %{ $fieldcanbe{$f} })[0];
                $n *= $myticket[$id];
            }
        }
        print "$n\n";
    }

    for my $f (keys %fieldcanbe) {
        next if !$fieldcanbe{$f}{$i};

        my %newfcb;
        for my $nf (keys %fieldcanbe) {
            my $href = $fieldcanbe{$nf};
            $newfcb{$nf} = {%$href};
            delete $newfcb{$nf}{$i};
        }
        $newfcb{$f} = {$i=>1};
        dfs($i+1, %newfcb);
    }
}
