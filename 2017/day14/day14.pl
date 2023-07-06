my $key = shift // 'hwlqcszp'; # default puzzle input

# The map is indexed by 128*row + col
my %map;

# Generate the map.
for my $row (0..127) {
  my $h = knotHash("$key-$row");
  my @bits = split //, unpack("B*", $h);
  for my $col (0..127) {
    $map{$row * 256 + $col} = 1 if $bits[$col];
  }
}

# Part 1 is just the count of on bits, which is everything that is now in
# the map.
my $part1 = scalar keys %map;

my @adj = ( -256, 256, -1, 1 );

# Find all contiguous regions within the map.
my $part2 = 0;
while(scalar keys %map > 0) {

  # pick one coordinate from the map; doesn't matter which.
  my $coord = (keys %map)[0];
  my @toCheck = ( $coord ); # queue of coordinates to check.
  delete $map{$coord};
  while(scalar @toCheck > 0) {
    $coord = shift @toCheck;
    for my $a (@adj) {
      my $newCoord = $coord + $a;
      if(exists $map{$newCoord}) {
        push @toCheck, $newCoord;
        delete $map{$newCoord};
      }
    }
  }

  # A contiguous region has been removed from the map, increment the
  # counter.
  $part2++;
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

# Following functions are taken from / adapted from day10.pl
#
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

sub knotHash {
  # The lengths to use are the byte values of the input string, with the
  # magic values (17, 31, 73, 47, 23) appended.
  my @lengths = map { ord($_) } split //, $_[0];
  push @lengths, 17, 31, 73, 47, 23;

  my @rope = (0..255);
  my $pos = 0;
  my $skip = 0;

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
  my @hash = ();
  while(scalar @rope > 0) {
    my $val = 0;
    for my $i (1..16) {
      $val ^= shift @rope;
    }
    push @hash, $val;
  }

  return pack("C16", @hash);
}
