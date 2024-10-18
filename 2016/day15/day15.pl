#!/usr/bin/perl

use strict 'vars';
use Math::Utils qw(lcm);

# Array of disc information. Each element is an array reference containing:
# [ location (x), number of positions (n), starting position (k) ]
my @discs;

# Read all input
while(<>) {
  if(/Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)/) {
    push @discs, [ $1, $2, $3 ];
  }
}

# First value for t where (t + x0 + k0) % n0 = 0 is n0 - x0 - k0.
my $t = $discs[0]->[1] - $discs[0]->[0] - $discs[0]->[2];
# Initial step is n0
my $step = $discs[0]->[1];

# Loop through all discs after the first.
for my $disc (@discs[1..$#discs]) {
  
  # Loop until ((t + x.d + k.d) % n.d) == 0
  while(($t + $disc->[0] + $disc->[2]) % $disc->[1]) {
    $t += $step;
  }

  # New step will be LCM($step, $n.d)
  $step = lcm($step, $disc->[1]);
}

print "Part 1 result: $t\n";

# Add in one more disc for part 2: [ $#discs + 2, 11, 0 ]
while(($t + $#discs + 2) % 11) {
  $t += $step;
}

print "Part 2 result: $t\n";
