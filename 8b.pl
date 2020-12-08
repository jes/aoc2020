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

for my $i (0 .. $#program) {
    if ($program[$i]{op} eq 'nop') {
        $program[$i]{op} = 'jmp';
        execute();
        $program[$i]{op} = 'nop';
    } elsif ($program[$i]{op} eq 'jmp') {
        $program[$i]{op} = 'nop';
        execute();
        $program[$i]{op} = 'jmp';
    }
}

sub execute {
    my %execed;

    my $pc = 0;
    my $acc = 0;

    while (1) {
        if ($pc == @program) {
            print "$acc\n";
            return 1;
        }
        if ($pc < 0 || $pc > @program) {
            return 0;
        }
        return if $execed{$pc};
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
