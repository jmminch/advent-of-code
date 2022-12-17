use List::Util qw(reduce);
use Data::Dumper;

# read the ingredient list
while(<>) {
  push @coeff, [];
  while(/([-\d]+)/g) {
    push @{$coeff[-1]}, $1;
  }
}

my @amount = ( 0 ) x scalar @coeff;
my $maxScore = findComb(\@amount, 0, 100);
print "part 1 result: $maxScore\n";

$part2 = 1;  # tells findComb to find the part 2 solution by ignoring any
             # recipe with calories != 500

$maxScore = findComb(\@amount, 0, 100);
print "part 2 result: $maxScore\n";

sub findComb {
  my ($amount, $idx, $total) = @_;

  if($idx == $#$amount) {
    # final ingredient!
    $amount->[$idx] = $total;

    # calculate scores.
    my @propScore = ( 0, 0, 0, 0, 0 );
    for my $i (0..$idx) {
      for my $j (0..4) {
        $propScore[$j] += $coeff[$i]->[$j] * $amount->[$i];
      }
    }

    # negative property scores result in a score of zero.
    for my $j (0..3) {
      return 0 if $propScore[$j] < 0;
    }

    return 0 if $part2 && $propScore[4] != 500;

    # score only based on the first 4 properties.
    pop @propScore;

    my $score = reduce { $a * $b } @propScore;
    return $score;
  } else {
    my $maxScore = -1;

    # try all possibilities for this ingredient.
    for my $amt (0..$total) {
      $amount->[$idx] = $amt;
      my $score = findComb($amount, $idx + 1, $total - $amt);
      $maxScore = $score if $score > $maxScore;
    }

    return $maxScore;
  }
}
