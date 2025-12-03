#!/usr/bin/perl

use strict vars;

# Read one machine definition at a time
$/ = "";

my $part1 = 0;
my $part2 = 0;
while(<>) {
  for my $offset (0, 10000000000000) {
    /Button A: X\+(\d+), Y\+(\d+)/;
    my $AX = $1; my $AY = $2;
    /Button B: X\+(\d+), Y\+(\d+)/;
    my $BX = $1; my $BY = $2;
    /Prize: X=(\d+), Y=(\d+)/;
    my $PX = $offset + $1; my $PY = $offset + $2;

    my $mA = $AY / $AX;
    my $mB = $BY / $BX;
    my $C = $PY - $PX * $BY / $BX;
    my $cx = $C / ($mA - $mB);
    my $aCount = $cx / $AX;
    my $bCount = ($PX - $cx) / $BX;

    # Ideally I'd check if aCount and bCount are integers, if so I have the
    # solution. However, because of FP error, I instead check the integers
    # around the solution I found to find the correct ones.

    for my $a (int($aCount) - 1..int($aCount) + 1) {
      for my $b (int($bCount) - 1..int($bCount) + 1) {
        if($a * $AX + $b * $BX == $PX &&
           $a * $AY + $b * $BY == $PY) {
          if($offset) {
            $part2 += $a * 3 + $b;
          } else {
            $part1 += $a * 3 + $b;
          }
        }
      }
    }
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
