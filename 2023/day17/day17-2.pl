use strict vars;

our @map = <>;
chomp @map;
@map = map { [ split // ] } @map;

printf "Part 1 result: %d\n", findBestPath(1, 3);
printf "Part 2 result: %d\n", findBestPath(4, 10);

# The parameters are the minimum and maximum straight line distances
# allowed in the path from the top left to bottom right corner.
sub findBestPath {
  my ($minLine, $maxLine) = @_;

  # State values are:
  # (x, y, arrival direction {0=horiz, 1=vert})
  my @queue = ( [ 0, 0, 0 ], [ 0, 0, 1 ]  );

  my %graph = ( "0.0.0" => 0, "0.0.1" => 0 );

  my @dirs = ( [1,0], [0,1], [-1,0], [0,-1] );

  while(my $state = shift @queue) {
    my ($x, $y, $dir) = @$state;

    next if $y == $#map && $x == $#{$map[0]};
    my $heat = $graph{"$x.$y.$dir"};

    # Choose the directions perpendicular to the arrival dir
    my @possDirs = ($dir == 0) ? (1, 3) : (0, 2);

    for my $newDir (@possDirs) {
      my $newHeat = $heat;
      my $nx = $x;
      my $ny = $y;
      for my $i (1..$maxLine) {
        $nx += $dirs[$newDir]->[0];
        $ny += $dirs[$newDir]->[1];
        last if $nx < 0 || $ny < 0 || $ny > $#map || $nx > $#{$map[0]};
        $newHeat += $map[$ny]->[$nx];
        next if $i < $minLine;
        my $newKey = "$nx.$ny." . ($dir ? "0" : "1");
        if(!exists $graph{$newKey} || $graph{$newKey} > $newHeat) {
          $graph{$newKey} = $newHeat;
          push @queue, [ $nx, $ny, ($dir ? 0 : 1) ];
        }
      }
    }
  }

  # Since we could have arrived from either direction, look for the minimum
  # at the destination square.
  my $tgty = $#map;
  my $tgtx = $#{$map[0]};
  my $minHeat = $graph{"$tgtx.$tgty.0"} < $graph{"$tgtx.$tgty.1"} ?
                    $graph{"$tgtx.$tgty.0"} : $graph{"$tgtx.$tgty.1"};

  return $minHeat;
}
