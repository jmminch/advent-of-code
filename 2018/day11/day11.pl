use strict vars;
use Memoize;

memoize('calcPower');
memoize('hlinePower');
memoize('vlinePower');

my $seed = shift // 7347;

our @map;

# Precalculate the map
# Note that coordinates are 1-based
for my $y (1..300) {
  $map[$y-1] = [ ];
  for my $x (1..300) {
    my $power = $x + 10;
    $power *= $y;
    $power += $seed;
    $power *= $x + 10;
    $power = int($power / 100) % 10;
    $power -= 5;
    $map[$y-1]->[$x-1] = $power;
  }
}

my $part1Power = -9e100;
my $part2Power = -9e100;
my ($part1, $part2);  # The results for parts one and two

# Try all square sizes
for my $sqSize (1..300) {
  
  # Look at each possible location
  for my $y (1..(301-$sqSize)) {
    for my $x (1..(301-$sqSize)) {
      my $power = calcPower($x, $y, $sqSize);
      if($sqSize == 3 && $power > $part1Power) {
        $part1Power = $power;
        $part1 = "$x,$y";
      }
      if($power > $part2Power) {
        $part2Power = $power;
        $part2 = "$x,$y,$sqSize";
      }
    }
  }

}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub calcPower {
  my ($x, $y, $sqSize) = @_;
  return $map[$y-1]->[$x-1] if $sqSize == 1;
  
  # Calculate the power as the power of the square one unit smaller, plus
  # the horizontal and vertical rows adjacent to it. The memoize function
  # should make this fast.
  my $power = calcPower($x, $y, $sqSize - 1);
  $power += hlinePower($x, $y + $sqSize - 1, $sqSize);
  $power += vlinePower($x + $sqSize - 1, $y, $sqSize - 1);
  return $power;
}

sub hlinePower {
  my ($x, $y, $len) = @_;
  return $map[$y-1]->[$x-1] if $len == 1;
  return hlinePower($x, $y, $len - 1) + $map[$y-1]->[$x-1+$len-1];
}

sub vlinePower {
  my ($x, $y, $len) = @_;
  return $map[$y-1]->[$x-1] if $len == 1;
  return vlinePower($x, $y, $len - 1) + $map[$y-1+$len-1]->[$x-1];
}
