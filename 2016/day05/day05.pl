use Digest::MD5 qw(md5_hex);

# Grab the door ID from the command line; default to my puzzle input.
my $doorId = shift // 'abbhdwsy';

# Generate MD5 hashes for the doorId concatenated with an increasing
# integer (starting from 0). We want to find the first 8 such hashes
# that start with 5 hexadecimal zeroes (for part 1). Part 2 will require
# finding more hashes.

my $idx = 0;
my $part1 = "";
my $part2 = "________";

while(1) {
  my $hash = md5_hex($doorId . $idx);
  if($hash =~ /^00000/) {
    my $c6 = substr($hash, 5, 1);

    # For part 1, add the sixth character of the hash to the password.
    $part1 .= $c6 if length $part1 < 8;

    # For part 2, if the sixth character is 0-7, then it is a position in
    # the password. If a character for that position has yet to be found,
    # then the seventh character should be in that position.
    if($c6 =~ /[0-7]/ and substr($part2, $c6, 1) eq '_') {
      substr($part2, $c6, 1) = substr($hash, 6, 1);
      last if not $part2 =~ /_/;
    }
  }

  $idx++;
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
