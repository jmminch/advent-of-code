#!/usr/bin/perl

use strict vars;

my $s = <>;
my $startLoc = index $s, 'S';
my %beams;
$beams{$startLoc} = 1;

my $part1 = 0;
my $part2 = 1; # We start with 1 universe
while(<>) {
  for(my $l = index $_, '^'; $l != -1; $l = index $_, '^', $l + 1) {
    if(exists $beams{$l}) {
      my $v = $beams {$l};
      delete $beams{$l};
      $beams{$l - 1} += $v;
      $beams{$l + 1} += $v;
      $part1++;
      $part2 += $v;
    }
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
