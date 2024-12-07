#!/usr/bin/perl

use strict vars;

my @rules;
my $part1 = 0;

# Read all input
while(<>) {
  chomp;
  if(/(\d+)\|(\d+)/) {
    # A rule; create a regex of the disallowed ordering.
    push @rules, ",$2,(.*,)?$1,";
  } elsif(/,/) {
    # A page list; check if it follows all rules. Note that all rules have
    # been read at this point.
    my $result = 1;
    for my $rule (@rules) {
      if(",$_," =~ /$rule/) {
        $result = 0;
        last;
      }
    }
    if($result) {
      my @pages = split /,/;
      $part1 += $pages[$#pages / 2]; # The middle page number.
    }
  }
}

print "Part 1 result: $part1\n";
