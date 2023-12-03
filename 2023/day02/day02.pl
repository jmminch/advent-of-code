my $part1 = 0;
my $part2 = 0;

LINE: while(<>) {

  # Determine the maximum number of each color on this line.
  my %max = ( );
  while(/(\d+) (blue|green|red)/g) {
    $max{$2} = $1 if $1 > $max{$2};
  }

  # Add the game id to part1 if none of the values are over the associated
  # limit.
  if($max{red} <= 12 && $max{green} <= 13 && $max{blue} <= 14) {
    /Game (\d+)/;
    $part1 += $1;
  }

  # Multiply the maximum values and add to part2
  $part2 += $max{red} * $max{green} * $max{blue};
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
