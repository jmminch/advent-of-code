#!/usr/bin/perl

use strict vars;

my $w = 101;
my $h = 103;
my $t = 100;

my @quadCounts;

while(<>) {
  next if !/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/;
  my ($x, $y, $vx, $vy) = ($1, $2, $3, $4);

  $x = ($x + $vx * $t) % $w;
  $y = ($y + $vy * $t) % $h;

  my $xquad = $x <=> ($w - 1) / 2;
  my $yquad = $y <=> ($h - 1) / 2;

  next if !$xquad || !$yquad;

  my $quad = ($xquad == 1) + 2 * ($yquad == 1);
  $quadCounts[$quad]++;
}

my $part1 = 1;
for my $c (@quadCounts) { $part1 *= $c; }
print "Part 1 result: $part1\n";

# Looking for a number t = 28+n*103, ((t - 55) % 101) == 0
my $t = 28;
while(($t - 55) % 101) {
  $t += 103;
}

print "Part 2 result: $t\n";
