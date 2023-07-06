# read the initial map
my %map;
my $y = 0;
my $w;
while(<>) {
  chomp;
  $w = length;
  my @cells = split //;
  for my $x (0..$#cells) {
    $map{"$x.$y"} = '#' if $cells[$x] eq '#';
  }
  $y++;
}

my $x = int($w / 2);
$y = int($y / 2);

# make a copy of the map since we need the original state for part 2.
my %mapPart2;
for my $k (keys %map) {
  $mapPart2{$k} = '#';
}

printf "Part 1 result: %d\n", simPart1(\%map, $x, $y);
printf "Part 2 result: %d\n", simPart2(\%mapPart2, $x, $y);

sub simPart1 {
  my ($map, $x, $y) = @_;
  my @moves = ( [0,-1], [1,0], [0,1], [-1,0] );
  my $dir = 0;
  my $infectCount = 0;

  # simulate 10,000 steps for part 1.
  for my $i (1..10000) {
    if($map->{"$x.$y"} eq '#') {
      # turn right if on an infected node
      $dir++;
      $dir = 0 if $dir == 4;

      # clean node
      delete $map->{"$x.$y"};
    } else {
      # turn left if on a clean node
      $dir--;
      $dir = 3 if $dir == -1;

      # infect node
      $map->{"$x.$y"} = '#';

      # count how many times a node was infected.
      $infectCount++;
    }

    # move forward
    $x += $moves[$dir]->[0];
    $y += $moves[$dir]->[1];
  }

  return $infectCount;
}

# similar to part 1, just with more complicated rules.
sub simPart2 {
  my ($map, $x, $y) = @_;
  my @moves = ( [0,-1], [1,0], [0,1], [-1,0] );
  my $dir = 0;
  my $infectCount = 0;

  # simulate 10,000,000 steps for part 1.
  for my $i (1..10000000) {
    my $coord = "$x.$y";
    if($map->{$coord} eq '#') {
      # infected node: turn right; mark node "flagged" (F)
      $dir++;
      $dir = 0 if $dir == 4;
      $map->{$coord} = 'F';
    } elsif($map->{$coord} eq 'W') {
      # weakened node: mark node "infected" (#)
      $map->{$coord} = '#';

      # count how many times a node was infected.
      $infectCount++;
    } elsif($map->{$coord} eq 'F') {
      # flagged node: turn around; mark node "clean" (delete)
      $dir += 2;
      $dir -= 4 if $dir > 3;
      delete $map->{$coord}
    } else {
      # clean node: turn left; mark node "weakened" (W)
      $dir--;
      $dir = 3 if $dir == -1;
      $map->{$coord} = 'W';
    }

    # move forward
    $x += $moves[$dir]->[0];
    $y += $moves[$dir]->[1];
  }

  return $infectCount;
}
