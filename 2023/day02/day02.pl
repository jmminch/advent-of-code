my %limits = ( red=>12, green=>13, blue=>14 );

LINE: while(<>) {

  # Determine if any values are more than the associated limit.
  while(/(\d+) (blue|green|red)/g) {
    next LINE if $limits{$2} < $1;
  }

  $part1 += $1 if /Game (\d+)/;
}

print "Part 1 result: $part1\n";
