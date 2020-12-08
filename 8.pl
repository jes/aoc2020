#!/usr/bin/perl

use strict;
use warnings;

my $n = 0;

my @program;

while (<>) {
    chomp;

    my ($op, $arg) = split / /;
    push @program, {
        op => $op,
        arg => $arg,
    };
}

execute();

sub execute {
    my %execed;

    my $pc = 0;
    my $acc = 0;

    while (1) {
        if ($execed{$pc}) {
            print "$acc\n";
            exit 0;
        }
        my $cmd = $program[$pc];
        $execed{$pc} = 1;

        if ($cmd->{op} eq 'nop') {
            $pc++;
        } elsif ($cmd->{op} eq 'acc') {
            $acc += $cmd->{arg};
            $pc++;
        } elsif ($cmd->{op} eq 'jmp') {
            $pc += $cmd->{arg};
        }
    }
}
