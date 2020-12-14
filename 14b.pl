#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max);

my $n = 0;

my %mem;
my $mask = '0'x36;

while (<>) {
    chomp;

    if (/^mem\[(\d+)\] = (\d+)$/) {
        my ($addr, $val) = ($1, $2);
        $mem{$_} = $val for permute($addr,$mask);
    } elsif (/^mask = (\w+)$/) {
        $mask = $1;
    } else {
        print "bad: $_\n";
    }
}

for my $k (keys %mem) {
    $n += $mem{$k};
}

print "$n\n";

sub permute {
    my ($val, $mask) = @_;

    my @addrs;

    my @bits = split //, reverse $mask;

    my $dfs;
    $dfs = sub {
        my ($addr_so_far, $bit) = @_;

        if ($bit == 36) {
            push @addrs, $addr_so_far;
            return;
        }

        if ($bits[$bit] eq '0') { # unchanged
            $dfs->($addr_so_far | ($val & (1 << $bit)), $bit+1);
        } elsif ($bits[$bit] eq '1') { # overwrite with 1
            $dfs->($addr_so_far | (1 << $bit), $bit+1);
        } else { # both 0 and 1
            $dfs->($addr_so_far, $bit+1);
            $dfs->($addr_so_far | (1 << $bit), $bit+1);
        }
    };

    $dfs->(0, 0);
    
    return @addrs;
}
