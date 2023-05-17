use strict 'vars';

# read in all the scanner definitions.
our %scan;
while(<>) {
  $scan{$1} = $2 if /(\d+): (\d+)/;
}

# Part 1: score for t0=0
printf "Part 1 result: %d\n", score(0);

# Part 2: find t where score(t) == 0
my $part2 = 0;
while(score($part2, 1) > 0) {
  $part2++;
}
print "Part 2 result: $part2\n";

# shortCircuit set to 1 bails out as soon as the score is determined to be
# nonzero, since for part 2 we don't care about the actual value of the
# score.
sub score {
  my ($t0, $shortCircuit) = @_;
  my $score = 0;

  for my $depth (keys %scan) {
    if (($t0 + $depth) % (2 * $scan{$depth} - 2) == 0) {
      $score += $depth * $scan{$depth};
      return 1 if $shortCircuit;
    }
  }
  return $score;
}
