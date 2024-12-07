#!/usr/bin/perl

use strict vars;

my $part1 = 0;
my $part2 = 0;

# Loop through each line
while(<>) {
  next if not /(\d+): (\d.*\d)\s*$/;
  my $result = $1;
  my @vals = split / /, $2;

  # validEq checks whether the equation can be valid for both part 1 and
  # part 2. Sum up the "result" field for each valid line.
  if(validEq(\@vals, $result)) {
    # Anything counted for part 1 is also OK for part 2, so no need to
    # check specifically for the part 2 rules.
    $part1 += $result;
    $part2 += $result;
  } else {
    $part2 += $result if validEq(\@vals, $result, 1);
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub validEq {
  # Since the equation is built up left-to-right, this works right-to-left.
  # Check whether we can get the specified result with the rightmost
  # value, combined with some operator and any combination of the left
  # values.
  my ($vals, $result, $part2) = @_;

  return 0 if $result < 0;
  return 0 if ($result - int($result)) > 0;

  if($#$vals == 0) {
    # Only one value in the list
    return ($vals->[0] == $result);
  } else {
    my @newVals = @{$vals};
    my $lastVal = pop @newVals;
    return 1 if validEq(\@newVals, $result - $lastVal, $part2);
    return 1 if validEq(\@newVals, $result / $lastVal, $part2);
    if($part2 && (length $result > length $lastVal) &&
       (substr($result, -(length $lastVal)) eq $lastVal)) {
      substr($result, -(length $lastVal)) = '';
      return 1 if validEq(\@newVals, $result, $part2);
    }
  }

  return 0;
}
