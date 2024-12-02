#!/usr/bin/perl

use strict vars;

my $part1 = 0;
my $part2 = 0;

# Count the number of lines for which checkPart1 and checkPart2 returns true.
while(<>) {
  my @vals = split /\s+/;
  $part1++ if checkPart1(@vals);
  $part2++ if checkPart2(@vals);
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub checkPart1 {
  my $inc = $_[0] < $_[1];

  # Find out the deltas between each set of numbers.
  for my $i (0..$#_ - 1) {
    my $d = $_[$i] - $_[$i + 1];
    # Check that each delta has the same sign as the first
    return 0 if ($inc && $d > 0) || (!$inc && $d < 0);
    # Check that the delta is between 1 and 3.
    return 0 if abs($d) < 1 || abs($d) > 3;
  }

  return 1;
}

sub checkPart2 {
  return 1 if checkPart1(@_);

  for my $i (0..$#_) {
    my @vals = @_;
    splice @vals, $i, 1;
    return 1 if checkPart1(@vals);
  }

  return 0;
}
