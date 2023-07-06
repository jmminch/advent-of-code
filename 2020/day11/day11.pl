use Data::Dumper;

my @lines = <>;
chomp @lines;
my @map = map { [ split // ] } @lines;

$part1 = simulate(\@map, part1Func);
print "part 1 result: $part1\n";
$part2 = simulate(\@map, part2Func);
print "part 2 result: $part2\n";

sub simulate {
  my ($map, $func) = @_;
  my $changed;

  do {
    $changed = 0;
    my $newMap = [ map { [] } (0..$#$map) ];

    for my $y (0..$#$map) {
      for my $x (0..$#{$map->[0]}) {
        $newMap->[$y]->[$x] = &$func($map, $x, $y);
        $changed++ if $newMap->[$y]->[$x] ne $map->[$y]->[$x];
      }
    }

    $map = $newMap;

  } while($changed > 0);

  # count all '#' cells
  my $count = 0;
  for my $row (@$map) {
    for my $char (@$row) {
      $count++ if $char eq '#';
    }
  }

  return $count;
}

sub part1Func {
  my ($map, $x, $y) = @_;
  @dirs = ( [-1,-1], [-1,0], [-1,1], [0,-1], [0,1], [1,-1], [1,0], [1,1] );

  return '.' if $map->[$y]->[$x] eq '.';

  # count adjacent occupied seats
  my $count = 0;
  for $dir (@dirs) {
    my $cx = $x + $dir->[0];
    my $cy = $y + $dir->[1];
    next if $cx < 0 || $cy < 0 || $cy > $#$map || $cx > $#{$map->[0]};
    $count++ if $map->[$cy]->[$cx] eq '#';
  }

  return '#' if $count == 0;
  return 'L' if $count >= 4;
  return $map->[$y]->[$x];
}

sub part2Func {
  my ($map, $x, $y) = @_;
  @dirs = ( [-1,-1], [-1,0], [-1,1], [0,-1], [0,1], [1,-1], [1,0], [1,1] );
  return '.' if $map->[$y]->[$x] eq '.';

  # count visible occupied seats
  my $count = 0;
  for $dir (@dirs) {
    my $cx = $x + $dir->[0];
    my $cy = $y + $dir->[1];
    while($cx >= 0 && $cy >= 0 && $cy <= $#$map && $cx <= $#{$map->[0]}) {
      my $ch = $map->[$cy]->[$cx];
      $count++ if $ch eq '#';
      last if $ch eq 'L' || $ch eq '#';
      $cx += $dir->[0];
      $cy += $dir->[1];
    }
  }

  return '#' if $count == 0;
  return 'L' if $count >= 5;
  return $map->[$y]->[$x];
}

sub printMap {
  print join("\n", map { join('', @$_) } @{$_[0]});
  print "\n";
}
