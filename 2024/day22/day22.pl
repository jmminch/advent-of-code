#!/usr/bin/perl

use strict vars;
use List::Util qw(max);

my %allDeltas = ( );
my $part1 = 0;
while(<>) {
  chomp;
  my $val = int($_);
  next if !$val;
  my @randVals = ( $val % 10 );
  for my $i (1..2000) {
    $val = nextRand($val);
    push @randVals, $val % 10;
  }
  $part1 += $val;

  my %deltas = ( );
  for my $i (0..$#randVals - 3) {
    my $d = 0;
    for my $x (0..3) {
      $d *= 20;
      $d += ($randVals[$i + $x + 1] - $randVals[$i + $x]) + 9;
    }

    next if exists $deltas{$d};
    $deltas{$d} = $randVals[$i + 4];
  }

  for my $d (keys %deltas) {
    $allDeltas{$d} += $deltas{$d};
  }
}

print "Part 1 result: $part1\n";
printf "Part 2 result: %d\n", max(values %allDeltas);


sub nextRand {
  my $val = $_[0];
  $val = (($val * 64) ^ $val) % 16777216;
  $val = (int(($val / 32)) ^ $val) % 16777216;
  $val = (($val * 2048) ^ $val) % 16777216;
  return $val;
}
