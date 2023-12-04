use strict vars;

my $part1 = 0;

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

    # Add 2^(winnerCount - 1)
    $part1 += 1 << ($winnerCount - 1);
  }
}

print "Part 1 result: $part1\n";
