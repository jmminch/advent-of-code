#!/usr/bin/perl

use strict vars;
use Memoize;

memoize('countStones');

my $input = <>;
chomp $input;
my @vals = split / /, $input;

my $part1 = 0;
my $part2 = 0;
for my $val (@vals) {
  $part1 += countStones($val, 25);
  $part2 += countStones($val, 75);
}
print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub countStones {
  my $val = $_[0];
  my $steps = $_[1];

  if($steps == 0) {
    return 1;
  }
  return countStones(1, $steps - 1) if $val == 0;

  my $l = length $val;
  if(($l & 1) == 0) {
    # even number of digits
    my $a = int(substr($val, 0, $l / 2));
    my $b = int(substr($val, $l / 2));
    return countStones($a, $steps - 1) + countStones($b, $steps - 1);
  }

  return countStones($val * 2024, $steps - 1);
}
