use Memoize;

our $seed = $ARGV[0];

my $part1Location = encode(31, 39);

memoize('isBlocked');

# Coordinates are encoded as (x + 512) | ((y + 512) << 16)
# Moving 1 in the y-direction adds/subtracts 65536; moving in the
# x-direction adds/subtracts 1.
my @dirs = ( -65536, 65536, -1, 1 );
my %dist;
$dist{encode(1,1)} = 0;
@queue = ( encode(1,1) );

my $part1 = -1;
my $part2 = 1;

while(scalar @queue) {
  my $pos = shift @queue;
  for my $dir (@dirs) {
    my $newpos = $pos + $dir;
    next if isBlocked($newpos) || exists $dist{$newpos};
    $newDist = $dist{$pos} + 1;
    $dist{$newpos} = $newDist;
    $part1 = $newDist if $newpos == $part1Location;
    $part2++ if $newDist <= 50;
    # Stop adding things to the queue if we've already found a solution to
    # part 1 and this location is too far away to count for part 2.
    push @queue, $newpos if ($part1 == -1 || $newDist <= 50);
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub isBlocked {
  my $coord = $_[0];
  my ($x, $y) = decode($coord);
  return 1 if $x < 0 || $y < 0;
  my $v = $x * $x + 3 * $x + 2 * $x * $y + $y + $y * $y;
  $v += $seed;
  # This is slow but simple.
  my $bitCount = 0;
  while($v) {
    $bitCount++ if $v & 1;
    $v >>= 1;
  }
  # True if bit count is odd, false if bit count is even.
  return ($bitCount & 1);
}

sub encode {
  my ($x, $y) = @_;
  return ($x + 512) | (($y + 512) << 16);
}

sub decode {
  my $coord = $_[0];
  my $x = ($coord & 0xFFFF) - 512;
  my $y = ($coord >> 16) - 512;
  return ($x, $y);
}
