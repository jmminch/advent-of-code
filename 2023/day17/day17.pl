use strict vars;

our @map = <>;
chomp @map;
@map = map { [ split // ] } @map;

printf "Part 1 result: %d\n", findBestPath(0, 3);
printf "Part 2 result: %d\n", findBestPath(4, 10);

sub findBestPath {
  my ($minLine, $maxLine) = @_;

  # State values are:
  # x, y, cur direction, num times moved in that dir, heat loss to this point

  my @states = ( [ 0, 0, 1, 0, 0 ] );

  my @dirs = ( [1,0], [0,1], [-1,0], [0,-1] );

  my %cache = ( );

  my $minHeat = 9e100;
  while(my $state = shift @states) {
    my ($x, $y, $dir, $ndir, $heat) = @$state;

    my $key = "$x,$y,$dir,$ndir";
    next if exists $cache{$key} && $cache{$key} <= $heat;
    $cache{$key} = $heat;

    if($y == $#map && $x == $#{$map[0]}) {
      next if $ndir < $minLine;
      if($heat < $minHeat) {
        $minHeat = $heat;
      }
      next;
    }

    if($heat > $minHeat) {
      next;
    }

    # Allow turning if the crucible has travelled at least $minLine in this
    # direction
    # Allow going straight unless the crucible has already travelled
    # $maxLine
    my @possDirs = ($dir - 1, $dir + 1) if $ndir >= $minLine;
    push(@possDirs, $dir) if $ndir < $maxLine;

    for my $cdir (@possDirs) {
      $cdir %= 4;
      my $nx = $x + $dirs[$cdir]->[0];
      my $ny = $y + $dirs[$cdir]->[1];
      next if $nx < 0 || $ny < 0 || $ny > $#map || $nx > $#{$map[0]};

      my $newHeat = $heat + $map[$ny]->[$nx];

      my $i;
      for($i = 0; $i <= $#states; $i++) {
        last if $states[$i]->[4] > $newHeat;
      }
      splice @states, $i, 0,
              [ $nx, $ny, $cdir, ($cdir == $dir) ? $ndir + 1 : 1,
                $newHeat ];
    }
  }

  return $minHeat;
}
