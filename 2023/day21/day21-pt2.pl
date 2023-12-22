use strict vars;

my $limit = shift // 2000;

# Read the map
our @map = <>;
chomp @map;
@map = map { [ split // ] } @map;

our $h = scalar @map;
our $w = $#{$map[0]} + 1;

our %distMap;  # distances to starting point

my @queue;
my @nextQueue;

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

my $maxX = $queue[0]->[0];
my $lastSq = 0;
for my $turn (1..$limit) {
  my $count = 0;
  while(my $c = shift @queue) {
    my $dist = getDist(@$c);
    next if $dist >= $limit;
    for my $dir (@dirs) {
      my $nx = $c->[0] + $dir->[0];
      my $ny = $c->[1] + $dir->[1];
      next if defined(getDist($nx, $ny));
      next if getMap($nx, $ny) eq '#';
      setDist($nx, $ny, $dist + 1);
      push @nextQueue, [$nx, $ny];
      $count++;
      $maxX = $nx if $nx > $maxX;
    }
  }

  if($maxX % 130 == 0) {
    my $delta = $count - $lastSq;
    $lastSq = $count;
    print "Step $turn   MaxX $maxX   Squares $count   Delta $delta\n";
  }
  @queue = @nextQueue;
  @nextQueue = ( );
}

sub getMap {
  my ($x, $y) = @_;
  $x %= $w;
  $y %= $h;
  return $map[$y]->[$x];
}

sub getDist {
  my ($x, $y) = @_;
  return $distMap{"$x,$y"};
}

sub setDist {
  my ($x, $y, $v) = @_;
  $distMap{"$x,$y"} = $v;
}
