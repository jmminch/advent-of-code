use strict vars;

my $target = 26501365;
my $limit = shift // 3000;

# Read the map
our @map = <>;
chomp @map;
@map = map { [ split // ] } @map;

our $h = scalar @map;
our $w = $#{$map[0]} + 1;

my $loopLen = ($h * 2);
my $initSteps = $target % $loopLen;

my $lastSet = { };
my $curSet = { };
my $nextSet = { };
my $maxX;

# Find the starting point
LOOP: for my $y (0..($h-1)) {
  for my $x (0..($w-1)) {
    if(getMap($x, $y) eq 'S') {
      $map[$y]->[$x] = '.';
      $curSet->{"$x,$y"} = 1;
      $maxX = $x;
      last LOOP;
    }
  }
}

my @dirs = ( [-1,0], [1,0], [0,-1], [0,1] );

my $total = ($target % 2) ? 0 : 1;
my $nextLoop = $initSteps;
my $lastLoopCount = 0;
for my $turn (1..$limit) {
  my $turnCount = 0;
  for my $sq (keys %$curSet) {
    my ($x, $y) = split /,/, $sq;
    my $dist = $turn - 1;
    for my $dir (@dirs) {
      my $nx = $x + $dir->[0];
      my $ny = $y + $dir->[1];
      next if exists $lastSet->{"$nx,$ny"};
      next if exists $nextSet->{"$nx,$ny"};
      next if getMap($nx, $ny) eq '#';
      $nextSet->{"$nx,$ny"} = 1;
      $turnCount++;
      $maxX = $nx if $nx > $maxX;
    }
  }

  $total += $turnCount if ($target & 1) == ($turn & 1);
  $nextLoop--;

  if($nextLoop == 0) {
    my $delta = $total - $lastLoopCount;
    $lastLoopCount = $total;
    $nextLoop = $loopLen;
    print "Step $turn   Squares $total  Delta $delta\n";
  }

  $lastSet = $curSet;
  $curSet = $nextSet;
  $nextSet = { };
}

print "Total: $total\n";

sub getMap {
  my ($x, $y) = @_;
  $x %= $w;
  $y %= $h;
  return $map[$y]->[$x];
}
