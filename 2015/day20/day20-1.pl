my $target = shift // 29000000;
my $verbose = shift;

$house = 0;
$presents = 0;

do {
  $house++;
  $presents = 10 * sumFactors($house);
  $maxPresents = $presents if $presents > $maxPresents;
  if(($house & 0xfff) == 0) {
    print "$house $maxPresents\n" if $verbose eq 'v';
  }
} while($presents < $target);

print "part 1 result: $house\n";

# find the sum of the factors of the input integer.
# To do so, find the prime factorization of the input. If the prime
# factorization is in the form N = A^x * B^y * C^z, then the sum of the
# factors is the sum of all possible combinations of those prime factors --
# (1 + A + A^2+...) * (1 + B + B^2+...) * ...
sub sumFactors {
  my $input = $_[0];
  my %factors = ( );

  return 1 if $input == 1;

  # first find the prime factorization of the input.
  my $f = 2;
  while($input > 1) {
    if($input % $f == 0) {
      $factors{$f}++;
      $input /= $f;
    } else {
      $f++;
      if($f > $input / 2) {
        $factors{$input}++;
        last;
      }
    }
  }

  # now find the sum by the formula above.
  my $total = 1;
  for my $f (keys %factors) {
    my $term = $f;
    my $sum = $f + 1;

    for my $i (2..$factors{$f}) {
      $term *= $f;
      $sum += $term;
    }
    $total *= $sum;
  }

  return $total;
}
