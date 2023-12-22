use strict vars;

my $limit = shift // 64;

# Read the map
our @map = <>;
chomp @map;
@map = map { [ split // ] } @map;

our $h = scalar @map;
our $w = $#{$map[0]} + 1;

our @distMap;  # distances to starting point
for my $y (1..$h) { push @distMap, [] };

my @queue;

# Find the starting point
LOOP: for my $y (0..($h-1)) {
  for my $x (0..($w-1)) {
    if(getMap($x, $y) eq 'S') {
      $map[$y]->[$x] = '.';
      setDist($x, $y, 0);
      push(@queue, [$x, $y]);
      last LOOP;
    }
  }
}

my @dirs = ( [-1,0], [1,0], [0,-1], [0,1] );

while(my $c = shift @queue) {
  my $dist = getDist(@$c);
  next if $dist >= $limit;
  for my $dir (@dirs) {
    my $nx = $c->[0] + $dir->[0];
    my $ny = $c->[1] + $dir->[1];
    next if defined(getDist($nx, $ny));
    next if getMap($nx, $ny) eq '#';
    setDist($nx, $ny, $dist + 1);
    push @queue, [$nx, $ny];
  }
}

my $part1 = 0;
for my $y (0..($h-1)) {
  for my $x (0..($w-1)) {
    my $dist = getDist($x, $y);
    $part1++ if defined($dist) && !($dist & 1);
  }
}

print "Part 1 result: $part1\n";

sub getMap {
  my ($x, $y) = @_;
  return '#' if $x < 0 || $y < 0 || $x >= $w || $y >= $h;
  return $map[$y]->[$x];
}

sub getDist {
  my ($x, $y) = @_;
  return undef if $x < 0 || $y < 0 || $x >= $w || $y >= $h;
  return $distMap[$y]->[$x];
}

sub setDist {
  my ($x, $y, $v) = @_;
  return if $x < 0 || $y < 0 || $x >= $w || $y >= $h;
  $distMap[$y]->[$x] = $v;
}
