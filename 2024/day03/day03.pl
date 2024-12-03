#!/usr/bin/perl

use strict vars;

# Part 1: sum up the result of all mul(x,y) sequences.
my $part1 = 0;

# Part 2: sum up all enabled mul(x,y) sequences.
my $part2 = 0;
my $enabled = 1;

while(<>) {
  while(/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/g) {
    if($& eq "do()") {
      $enabled = 1;
    } elsif($& eq "don't()") {
      $enabled = 0;
    } else {
      $part1 += $1 * $2;
      $part2 += $1 * $2 if $enabled;
    }
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
