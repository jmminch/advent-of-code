use List::Util qw(min max);

# Go through the input line by line.
while(<>) {
  # Each line is a whitespace-separated list of numbers;
  # split it into an array.
  @vals = split /\s+/;

  # For part 1, find the min and max value, and then their difference.
  $part1 += max(@vals) - min(@vals);

  # For part 2, find two numbers that are evenly divisible, and sum the
  # quotients.
  LOOP: for my $i (0..$#vals) {
    for my $j (0..$#vals) {
      next if $i == $j;
      if($vals[$j] > 0 && ($vals[$i] % $vals[$j]) == 0) {
        $part2 += $vals[$i] / $vals[$j];
        last LOOP;
      }
    }
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
