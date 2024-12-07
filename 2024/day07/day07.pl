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
  $part1 += $result if validEq($result, \@vals);
  $part2 += $result if validEq($result, \@vals, 1);
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

# Check whether the list of numbers given can be combined to make the given
# result value. If the third parameter is false, then evaluate based on part
# 1 rules (use only + and *); if the third parameter is true then evaluate
# based on part 2 rules (also allow concat.)
#
# Note that this is stupid for part 1; we find and then discard all cases
# where concat is used.
sub validEq {
  # We need to try (# of vals) - 1 operators; 3^n combinations.
  my $nOp = scalar(@{$_[1]}) - 1;
  my $maxOp = 3 ** $nOp - 1;

  # Loop through every possible combination of operators.
  for my $op (0..$maxOp) {
    return 1 if evalEq($_[1], $op, $_[2]) == $_[0];
  }
  
  return 0;
}

# Evaluate the number list based on the combination of operators specified.
sub evalEq {
  my @vals = @{$_[0]};
  my $op = $_[1];
  my $r = shift @vals;
  while(my $x = shift @vals) {
    my $op0 = $op % 3;
    if($op0 == 0) {
      $r += $x;
    } elsif($op0 == 1) {
      $r *= $x;
    } else {
      return -1 if $_[2] == 0; # part 1, concat disallowed
      $r = $r . $x;
    }
    $op = int($op / 3);
  }
  return $r;
}
