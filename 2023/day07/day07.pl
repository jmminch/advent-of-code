use strict vars;
use Data::Dumper;

my @hands;

# Read the hands. Store the cards and the bid, and convert the cards to a
# contiguous representation using letters a-m (m high)
while(<>) {
  push @hands, [ $1 =~ tr/2-9TJQKA/a-m/r, $2 ] if /^(.{5})\s+(\d+)/;
}

# Sort the hands in ascending order
@hands = sort handSort @hands;

# Calculate the total winnings.
my $winnings = 0;
for my $i (0..$#hands) {
  $winnings += ($i + 1) * $hands[$i]->[1];
}

print "Part 1 result: $winnings\n";

sub handSort {
  # Compare the rank of the hands.
  my $rankA = handRank($a->[0]);
  my $rankB = handRank($b->[0]);
    
  # If ranks are equal, do a lexical comparison
  return $a->[0] cmp $b->[0] if $rankA == $rankB;

  return $rankA <=> $rankB;
}

sub handRank {
  # Count the number of each character in hand
  my %counts;
  for my $c (split //, $_[0]) {
    $counts{$c}++;
  }

  # Now figure out how many of each count there are
  my %counts2;
  for my $count (values %counts) {
    $counts2{$count}++;
  }

  # Now return a value indicating the rank
  return 9 if $counts2{5} > 0;  # five of a kind
  return 8 if $counts2{4} > 0;  # four of a kind
  return 7 if $counts2{3} > 0 && $counts2{2} > 0; # full house
  return 6 if $counts2{3} > 0;  # three of a kind
  return 5 if $counts2{2} > 1;  # two pair
  return 4 if $counts2{2} > 0;  # one pair
  return 3;                     # high card
}
