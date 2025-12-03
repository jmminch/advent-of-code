#!/usr/bin/perl

use strict vars;

my $part1 = 0;
my $part2 = 0;

while(<>) {
  chomp;
  my @digits = split //;

  # Part 1: Max joltage with 2 batteries
  $part1 += maxJoltage(\@digits, 0, 2);
  # Part 2: Max joltage with 12 batteries
  $part2 += maxJoltage(\@digits, 0, 12);
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub maxJoltage {
  my ($digits, $start, $n) = @_;

  my $d = 0;
  my $idx;

  # Find the largest digit between $start and $#digits - n + 1. Work
  # backwards to also determine the location of that digit.
  for(my $i = $#$digits - $n + 1; $i >= $start; $i--) {
    $d = $digits->[$i] if $digits->[$i] > $d;
    $idx = $i if $d == $digits->[$i];
  }

  return $d if $n == 1;
  return $d . maxJoltage($digits, $idx + 1, $n - 1);
}
