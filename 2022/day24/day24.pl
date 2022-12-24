use Data::Dumper;

# read the map
my @input = <>;
chomp @input;

# find map size and bounds.
$mapWidth = length($input[0]) - 2;
$mapHeight = (scalar @input) - 2;
$start = [ index($input[0], '.') - 1, -1 ];
$end = [ index($input[-1], '.') - 1, $mapHeight ];

# find location and direction of all blizzards
my %dirMap = ( '^'=>0, 'v'=>1, '<'=>2, '>'=>3 );

# the last entry is for waiting in place
@dirs = ( [0,-1], [0,1], [-1,0], [1,0], [0,0] );

for (my $y = 0; $y < $mapHeight; $y++) {
  while($input[$y + 1] =~ /[\^v><]/g) {
    push @blizzard,
      [ $-[0] - 1, $y, $dirMap{substr($input[$y + 1], $-[0], 1)} ];
  }
}

# pathfinding from start to end.
my $steps = findPath($start->[0], $start->[1], $end->[0], $end->[1]);

print "part 1 result: $steps\n";

# for part 2, go back to the start then return to the end.
$steps += findPath($end->[0], $end->[1], $start->[0], $start->[1]);
$steps += findPath($start->[0], $start->[1], $end->[0], $end->[1]);

print "part 2 result: $steps\n";

sub moveBlizzards {
  # clear existing blizzard map
  %blizzMap = ( );
  for my $b (@blizzard) {
    $b->[0] += $dirs[$b->[2]]->[0];
    $b->[1] += $dirs[$b->[2]]->[1];

    $b->[0] = $mapWidth - 1 if $b->[0] < 0;
    $b->[0] = 0 if $b->[0] >= $mapWidth;
    $b->[1] = $mapHeight - 1 if $b->[1] < 0;
    $b->[1] = 0 if $b->[1] >= $mapHeight;

    $blizzMap{"$b->[0].$b->[1]"} = 1;
  }
}

# return true if a move to this location is allowed.
sub locOk {
  my ($x, $y) = @_;
  return 0 if $x < 0 || $x >= $mapWidth || $y < -1 || $y > $mapHeight;
  return 0 if ($y == -1 && $x != $start->[0]);
  return 0 if ($y == $mapHeight && $x != $end->[0]);
  return 0 if exists $blizzMap{"$x.$y"};
  return 1;
}

sub findPath {
  my ($xs, $ys, $xe, $ye) = @_;
  # the keys of this hash are the locations that need to be checked in the
  # next step.
  my %next = ("$xs.$ys" => 1);
  my $steps = 0;

  while(1) {

    # move all blizzards first, so that we can check which locations are ok
    # this turn.
    $steps++;
    moveBlizzards();

    my @queue = keys %next;
    %next = ( );
    if(scalar @queue == 0) {
      print "no path found!\n";
      print "steps=$steps\n";
      exit 1;
    }

    for $loc (@queue) {
      my ($x, $y) = split /\./, $loc;
      
      for $dir (@dirs) {
        my $nx = $x + $dir->[0];
        my $ny = $y + $dir->[1];

        if(locOk($nx, $ny)) {
          if($nx == $xe && $ny == $ye) {
            return $steps;
          }

          $next{"$nx.$ny"} = 1;
        }
      }

    }
  }
}
