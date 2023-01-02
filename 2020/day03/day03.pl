# read the map
@lines = <>;
chomp @lines;

# part 1 wants the number of trees for slope 3,1; part 2 wants the product
# of the number of tress for several slopes.
my $part1 = checkSlope(3, 1);
my $part2 = 1;
$part2 *= checkSlope(1, 1);
$part2 *= checkSlope(3, 1);
$part2 *= checkSlope(5, 1);
$part2 *= checkSlope(7, 1);
$part2 *= checkSlope(1, 2);

print "part 1 result: $part1\n";
print "part 2 result: $part2\n";

sub checkSlope {
  # dx, dy are how far to move each step
  my ($dx, $dy) = @_;
  # start in the upper left corner
  my $x = 0;
  my $y = 0;
  my $trees = 0;

  # quit after going off the bottom of the map
  while($y <= $#lines) {
    my $ch = substr($lines[$y], $x, 1);
    $trees++ if $ch eq '#';

    # the x-values wrap around (since the map repeats infinitely to the
    # right.)
    $x += $dx;
    $x %= length $lines[$y];
    $y += $dy;
  }
  return $trees;
}
