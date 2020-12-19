#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(min max sum product all);

my $n = 0;

my %rule;

while (<>) {
    chomp;
    last if $_ eq '';

    if (/^(\d+): (.*)$/) {
        my ($rulenum, $rule) = ($1, $2);
        if ($rule =~ /^"(\w)"$/) {
            $rule{$rulenum} = {
                type => 'terminal',
                char => $1,
            };
        } else {
            my @rules = split /\s*\|\s*/, $rule;
            $rule{$rulenum} = {
                type => 'rule',
                rules => \@rules,
            };
        }
    } else {
        print "bad: $_\n";
    }
}

# 0: 8 11
# 8: 42 | 42 8 == 42 as many times as you want
# 11: 42 31 | 42 11 31 == some number of 42 followed by equal number of 31
# 0 == some number of 42 followed by smaller number of 31

my @chars;
my $cp = 0;

while (<>) {
    chomp;
    @chars = split //;
    $n++ if bigmatch();
}

print "$n\n";

# check if @chars matches some number of rule 42 followed by some smaller number of rule 31
sub bigmatch {
    LOOP:
    for my $n (1 .. @chars) {
        $cp = 0;
        for my $i (1..$n) {
            next LOOP if !match(42);
        }
        for my $j (1..$n-1) {
            next LOOP if !match(31);
            return 1 if $cp == @chars;
        }
    }
    return 0;
}

sub match {
    my ($r) = @_;

    if ($rule{$r}{type} eq 'rule') {
        my $orig_cp = $cp;
        for my $rule (@{ $rule{$r}{rules} }) {
            return 1 if all { match($_) } split / /, $rule;
            $cp = $orig_cp;
        }
    } elsif ($rule{$r}{type} eq 'terminal') {
        return 0 if $cp >= @chars;
        return 1 if $chars[$cp++] eq $rule{$r}{char};
    }

    return 0;
}
