# read input sublist length data.
$input = <>;
chomp $input;
my @lengths = split /,/, $input;

# initial state of the rope.
my @rope = (0..255);
my $pos = 0;
my $skip = 0;

for my $len (@lengths) {
  reverseSublist(\@rope, $pos, $len);
  $pos = ($pos + $len + $skip) % 256;
  $skip++;
}

printf "Part 1 result: %d\n", $rope[0] * $rope[1];

# For part 2, rules change a bit. Reset the state of the rope.
@rope = (0..255);
$pos = 0;
$skip = 0;

# The lengths to use now are the byte values of the input string, with the
# magic values (17, 31, 73, 47, 23) appended.
@lengths = map { ord($_) } split //, $input;
push @lengths, 17, 31, 73, 47, 23;

# now run 64 iterations of the knot hash. "pos" and "skip" are retained
# between rounds.
for my $i (1..64) {
  for my $len (@lengths) {
    reverseSublist(\@rope, $pos, $len);
    $pos = ($pos + $len + $skip) % 256;
    $skip++;
  }
}

# create the "dense hash" by xoring together each 16 elements of the rope.
while(scalar @rope > 0) {
  my $val = 0;
  for my $i (1..16) {
    $val ^= shift @rope;
  }
  push @hash, $val;
}

# print out the hex representation of the 16 values in @hash.
$part2 = join '', map { sprintf "%.2x", $_ } @hash;
print "Part 2 result: $part2\n";

# reverse part of the given list, possibly wrapping around from the end of
# the list to the beginning.
sub reverseSublist {
  my ($rope, $pos, $len) = @_;
  my $end = $pos + $len - 1;

  while($pos < $end) {
    # swap the elements at "pos" and "end".
    my $tmp = $rope->[$pos % 256];
    $rope->[$pos % 256] = $rope->[$end % 256];
    $rope->[$end % 256] = $tmp;

    # move the ends of the range towards each other.
    $pos++;
    $end--;
  }
}
