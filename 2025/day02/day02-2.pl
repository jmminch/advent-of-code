#!/usr/bin/perl

use strict vars;

my $input = <>;

my (%part1Ids, %part2Ids);

while($input =~ /(\d+)-(\d+)/g) {
  for my $range (splitRange($1, $2)) {
    my $L = length $range->[0];
    my $maxL = int($L / 2);

    # If L is even, then check prefixes with length L/2.
    if(!($L & 1)) {
      findInvalidIds($range->[0], $range->[1], $maxL, \%part1Ids);
    }

    # For part 2, check all lengths from 1 to maxL
    for my $l (1..$maxL) {
      # Skip lengths that are not a factor of L.
      next if $L % $l;

      findInvalidIds($range->[0], $range->[1], $l, \%part2Ids);

    }
  }
}

my ($part1, $part2);
for my $id (keys %part1Ids) { $part1 += $id; };
for my $id (keys %part2Ids) { $part2 += $id; };

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";


# Split up a range of numbers into multiple ranges, each containing numbers
# with the same number of digits.
sub splitRange {
  my ($x, $y) = @_;
  my @r;
  return [$x, $y] if length $x == length $y;
  my @r = ( [ $x, '9' x length $x ] );
  push @r, splitRange($r[0]->[1] + 1, $y);
  return @r;
}

# Find all invalid IDs in the given range and add the ID to the output hash.
sub findInvalidIds {
  my ($x, $y, $l, $out) = @_;
  my $pfx0 = substr($x, 0, $l);
  my $pfx1 = substr($y, 0, $l);
  my $repeat = length($x) / $l;
  for my $pfx ($pfx0..$pfx1) {
    my $id = $pfx x $repeat;
    if($id >= $x && $id <= $y) {
      $out->{$id} = 1;
    }
  }
}
