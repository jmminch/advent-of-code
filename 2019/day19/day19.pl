#!/usr/bin/perl

require "./intcode.pl";

use strict vars;

my $icInput = <>;
chomp;

# For part 1, determine how many of the squares within a 50x50 box result in
# 1.
my $part1;
for my $y (0..50) {
  for my $x (0..50) {
    my @code = split /,/, $icInput;
    my @input = ($x, $y);
    my $output;
    runIntcode(\@code, sub { shift @input }, sub { $output = $_[0] });
    $part1++ if $output;
  }
}

print "Part 1 result: $part1\n";

# For part 2, look for the bottom-left corner of a 50x50 square.
my $y = 99;
my $x = 0;
while(1) {
  # Look for the first "on" square in this line, starting at the current x
  # value.
  while(1) {
    my @code = split /,/, $icInput;
    my @input = ($x, $y);
    my $output;
    runIntcode(\@code, sub { shift @input }, sub { $output = $_[0] });
    last if $output;

    $x++;
  }

  # Check whether the square (x+99, y-99) is also on.
  my @code = split /,/, $icInput;
  my @input = ($x + 99, $y - 99);
  my $output;
  runIntcode(\@code, sub { shift @input }, sub { $output = $_[0] });
  last if $output;

  $y++;
}

# $x, $y is the coordinate of the bottom-left corner. The question wants the
# top-left corner.
$y -= 99;

printf "Part 2 result: %d\n", $x * 10000 + $y;
