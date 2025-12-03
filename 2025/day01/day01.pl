#!/usr/bin/perl

use strict vars;
use builtin 'floor';

my $pos = 50;
my $part1 = 0;
my $part2 = 0;

while(<>) {
  if(/([LR])(\d+)/) {
    my $val = $2;
    $val = -$val if $1 eq 'L';
    my $X = $pos;
    $pos += $val;

    # Check the number of multiples of 100 between X (exclusive) and pos
    # (inclusive).
    if($X < $pos) {
      $part2 += floor($pos / 100) - floor($X / 100);
    } else {
      $part2 += floor(($X-1) / 100) - floor(($pos - 1) / 100);
    }
    $pos %= 100;
    $part1++ if $pos == 0;
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
