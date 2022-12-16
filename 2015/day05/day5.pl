# determine which strings match a set of rules (see notes)

$part1 = 0;
$part2 = 0;
while(<>) {
  my $vowels = () = /[aeiou]/g;

  if(!/(ab|cd|pq|xy)/ &&
      /(.)\1/ &&
      $vowels >= 3) {
    $part1++;
  }

  if(/(..).*\1/ &&
     /(.).\1/) {
    $part2++;
  }
}

print "part 1 result: $part1\n";
print "part 2 result: $part2\n";
