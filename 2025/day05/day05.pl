#!/usr/bin/perl

use strict vars;

my @ranges;
my @avail;

while(<>) {
  if(/(\d+)-(\d+)/) {
    push @ranges, [ $1, $2 ];
  } elsif(/(\d+)/) {
    push @avail, $1;
  }
}

# Combine any ranges that overlap.

# Sort ranges by starting ID.
@ranges = sort { $a->[0] <=> $b->[0] } @ranges;

for(my $i = 0; $i <= $#ranges; $i++) {
  # For this range, check if it overlaps any range later in the list.
  for(my $j = $i + 1; $j <= $#ranges; $j++) {
    # Since the ranges are sorted in ascending order of starting ID, if the
    # starting ID for this range comes after the ending ID for current
    # range, then no further ranges will overlap.
    last if $ranges[$j]->[0] > $ranges[$i]->[1] + 1;

    # This overlaps. Update the end of the range if required.
    $ranges[$i]->[1] = $ranges[$j]->[1] 
            if $ranges[$j]->[1] > $ranges[$i]->[1];

    # Delete the range at index j and continue from there.
    splice @ranges, $j, 1;
    $j--;
  }
}

# For part 1: Determine how many IDs from the list avail fall within any of
# the ranges.
my $part1 = 0;

LOOP: for my $id (@avail) {
  for my $r (@ranges) {
    if($id >= $r->[0] && $id <= $r->[1]) {
      $part1++;
      next LOOP;
    }
  }
}

print "Part 1 result: $part1\n";

# For part 2: Determine the extent of all the ranges. Since any overlapping
# ranges have already been combined, just return the total size of all
# ranges.
my $part2 = 0;
for my $r (@ranges) {
  $part2 += $r->[1] - $r->[0] + 1;
}
print "Part 2 result: $part2\n";
