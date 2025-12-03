#!/usr/bin/perl

use strict vars;

my $input = <>;

my $part1 = 0;
my $part2 = 0;

while($input =~ /(\d+)-(\d+)/g) {
  for my $id ($1..$2) {
    $part1 += $id if invalidId($id);
    $part2 += $id if invalidId2($id);
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub invalidId {
  my $id = $_[0];
  my $ndigits = length $id;
  # Cannot be an invalid ID if there is an odd number of digits
  return 0 if ($ndigits & 1);

  # Check if the first half of the digits matches the second half.
  my $half = $ndigits >> 1;
  return 1 if substr($id, 0, $half) eq substr($id, $half);

  return 0;
}

sub invalidId2 {
  my $id = $_[0];
  my $ndigits = length $id;
  my $half = $ndigits / 2;

  # Check all possible repeat lengths from 1 to ndigits / 2
  LOOP: for my $l (1..$half) {

    # Can only be a repeat with length l if ndigits is a multiple of l
    next if $ndigits % $l > 0;

    my $pfx = substr($id, 0, $l);
    for(my $s = $l; $s < $ndigits; $s += $l) {
      # Skip to the next length check if any of the substrings don't match.
      next LOOP if $pfx ne substr($id, $s, $l);
    }

    # Found a repeated string, this id is invalid.
    return 1;
  }

  return 0;
}
