my $target = shift // 150; # default to 150; test data uses 25

# read the capacities of the containers, one per line.
while(<>) {
  push @cap, int($_) if /(\d)/;
}

my $combinations = 0; # combinations found for part 1 result.
my $part2 = 0;
my $minCount = 9999;

# bits is a bitfield, where bit 0 corresponds to the first container in
# @cap, etc. By iterating bits from 0 to (2^n - 1), we cover all possible
# combinations of containers. (I start at 1 since 0 can't possibly be a
# solution.)
#
# Possible optimization: if the beginning set of bits creates a result that
# is too high, then you can skip all values until reaching one that changes
# that set of bits.
my $max = (1 << (scalar @cap)) - 1;
for my $bits (1..$max) {
  my $total = 0;
  my $count = 0;

  # loop through all containers and increment the total if the corresponding
  # bit is on. Also count the bits that are on at the same time.
  for my $i (0..$#cap) {
    if($bits & (1 << $i)) {
      $total += $cap[$i];
      $count++;
    }
  }

  if($total == $target) {
    # This combination matches the target; increment counters.
    $combinations++;
    if($count < $minCount) {
      $part2 = 1;
      $minCount = $count;
    } elsif($count == $minCount) {
      $part2++;
    }
  }
}

print "part 1 result: $combinations\n";
print "part 2 result: $part2\n";
