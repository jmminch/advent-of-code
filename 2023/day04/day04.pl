use Memoize;
use strict vars;

memoize('part2Score');

# Number of winners for each card
our @winners;

while(<>) {
  if(/:([\d\s]*)\|([\d\s]*)$/) {
    my $winners = $1;
    my $nums = $2;
    my %winnerList = ( );
    my $winnerCount = 0;

    # Add all winning numbers to a hash.
    while($winners =~ /(\d+)/g) {
      $winnerList{$1} = 1;
    }

    # Now count how many numbers in the nums list are in winnerList
    while($nums =~ /(\d+)/g) {
      $winnerCount++ if exists $winnerList{$1};
    }

    push @winners, $winnerCount;

  }
}

my $part1 = 0;
my $part2 = 0;

for my $i (0..$#winners) {
  # part1 is the sum of 2^(winnerCount - 1)
  $part1 += 1 << ($winners[$i] - 1);

  $part2 += part2Score($i);
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub part2Score {
  my $total = 1; # start by counting this card
  for(my $i = 0; $i < $winners[$_[0]]; $i++) {
    last if $i + $_[0] > $#winners;
    $total += part2Score($_[0] + $i + 1);
  }
  return $total;
}
