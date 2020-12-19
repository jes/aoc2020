#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(all);

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

my @chars;
my $cp = 0;

while (<>) {
    chomp;
    @chars = split //;
    $cp = 0;
    if (match(0)) {
        $n++ if $cp == @chars;
    }
}

print "$n\n";

sub match {
    my ($r) = @_;

    # TODO: return 0 if $r is already in call stack with same $cp

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
