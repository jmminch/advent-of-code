# Jump instructions are a list of numbers.
my @inst = <>;
$part2 = 0; # set to 1 to force sim() to use part 2 logic

# Make a copy of the array since sim() is going to change it.
my @tmpinst = @inst;
my $part1result = sim(@tmpinst);

# Repeat the simulation with part 2 rules.
$part2 = 1;
my $part2result = sim(@inst);

print "Part 1 result: $part1result\n";
print "Part 2 result: $part2result\n";

sub sim {
  # jump instructions in the @_ array.
  my $p = 0;
  my $steps = 0;
  while($p >= 0 && $p <= $#_) {
    my $newp = $p + $_[$p];
    if($part2) {
      if($_[$p] >= 3) {
        $_[$p]--;
      } else {
        $_[$p]++;
      }
    } else {
      $_[$p]++;
    }
    $p = $newp;
    $steps++;
  }
  return $steps;
}
