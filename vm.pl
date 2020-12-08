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

print execute(@program), "\n";

sub execute {
    my (@program) = @_;

    my %execed;

    my $pc = 0;
    my $acc = 0;

    while (1) {
        if ($pc == @program) { # try to execute instruction immediately after program
            return $acc;
        }
        if ($pc < 0 || $pc > @program) { # try to execute instruction out of range
            return undef;
        }
        if ($execed{$pc}) { # infinite loop
            return undef;
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
