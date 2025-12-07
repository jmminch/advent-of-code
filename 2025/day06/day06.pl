#!/usr/bin/perl

use strict vars;

my @sheet = <>;
chomp @sheet;
@sheet = map { [ split // ] } @sheet;

# Array of the locations of each problem. The first one starts at offset 0.
my @pbmLoc = ( 0 );

COL: for my $i (0..$#{$sheet[0]}) {
  for my $j (0..$#sheet) {
    next COL if $sheet[$j]->[$i] ne ' ';
  }
  push @pbmLoc, $i + 1;
}

my $part1 = 0;
my $part2 = 0;

# Iterate through all the problems
for my $i (0..$#pbmLoc) {
  my $sx = $pbmLoc[$i];
  my $ex = $pbmLoc[$i + 1] - 2;
  $ex = $#{$sheet[0]} if $ex < 0;

  # Figure out the operator for this problem.
  my $op;
  for my $j ($sx..$ex) {
    $op = $sheet[-1]->[$j];
    last if $op ne ' ';
  }

  # Extract values for part 1
  my @vals = ( );
  for my $j (0..$#sheet - 1) {
    push @vals, int(join '', @{$sheet[$j]}[$sx..$ex]);
  }
  if($op eq '+') {
    my $r = 0;
    for my $d (@vals) { $r += $d }
    $part1 += $r;
  } else {
    my $r = 1;
    for my $d (@vals) { $r *= $d }
    $part1 += $r;
  }

  # Repeat for part 2
  @vals = ( );
  for my $j ($sx..$ex) {
    my $v = '';
    for my $k (0..$#sheet - 1) {
      $v .= $sheet[$k]->[$j];
    }
    push @vals, $v;
  }
  if($op eq '+') {
    my $r = 0;
    for my $d (@vals) { $r += $d }
    $part2 += $r;
  } else {
    my $r = 1;
    for my $d (@vals) { $r *= $d }
    $part2 += $r;
  }


}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
