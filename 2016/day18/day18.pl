#!/usr/bin/perl

use strict 'vars';

# Read the input state, and then add safe tiles at the edges.
my $line = <>;
chomp $line;
$line = "." . $line . ".";

my ($part1, $part2);

my $safeCount = ($line =~ tr/.//) - 2;
for my $i (1..399999) {
  # count safe tiles; subtract 2 because the edges don't count.

  $line = step($line);
  $safeCount += ($line =~ tr/.//) - 2;

  $part1 = $safeCount if $i == 39;
  $part2 = $safeCount if $i == 399999;
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub step {
  my $line = $_[0];
  my $out = ".";  # leftmost character is '.'
  # If rules for the three tiles around the new tile is 1, then the
  # new tile is '^'; otherwise it's '.'
  my %rules = ( "^^." => 1, ".^^" => 1, "^.." => 1, "..^" => 1 );

  # step through characters. $i is the index of the cell to the left of the
  # one that we're evaluating.
  for my $i (0 .. length($line) - 3) {
    $out .= (exists $rules{substr($line, $i, 3)}) ? '^' : '.';
  }

  $out .= '.';  # rightmost character
  return $out;
}
