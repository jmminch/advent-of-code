use strict 'vars';

# read input data.
our @parts;
while(<>) {
  push @parts, [ $1, $2 ] if /(\d+)\/(\d+)/;
}

our $maxStrength = -1;
our $maxLength = -1;
our $part2Strength = -1;

# Rather than modify the list of parts, the "used" list is used to track
# which parts have been used. If the corresponding element is nonzero, then
# it's been used earlier in the chain, so skip it.
our @used;

# Find chains that start with 0.
# Parameters are: current end value, current chain length,
#                 current chain strength.
findChains(0, 0, 0);

sub findChains {
  my ($end, $len, $strength) = @_;
  my $found = 0;

  # Look through unused parts to find any that match the $end value.
  for my $i (0..$#parts) {
    next if $used[$i];
    if($parts[$i]->[0] == $end) {
      $found = 1;
      $used[$i] = 1;
      findChains($parts[$i]->[1], $len + 1,
                 $strength + $parts[$i]->[0] + $parts[$i]->[1]);
      $used[$i] = 0;
    } elsif($parts[$i]->[1] == $end) {
      $found = 1;
      $used[$i] = 1;
      findChains($parts[$i]->[0], $len + 1,
                 $strength + $parts[$i]->[0] + $parts[$i]->[1]);
      $used[$i] = 0;
    }
  }

  if(!$found) {
    # no further parts could be added to this chain. Possibly store away the
    # strength/length of this chain as a potential solution.
    $maxStrength = $strength if $strength > $maxStrength;
    if($len >= $maxLength) {
      # If this is the new max length, then unconditionally set
      # part2Strength; otherwise only set it if the strength is greater than
      # the current value of part2Strength.
      $part2Strength = $strength if $len > $maxLength || $strength > $part2Strength;
      $maxLength = $len;
    }
  }
}

print "Part 1 result: $maxStrength\n";
print "Part 2 result: $part2Strength\n";
