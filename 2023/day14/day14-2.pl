use strict vars;
use Storable qw(dclone);

# Read input into a 2D array of characters
my @map = <>;
chomp @map;
@map = map { [ split // ] } @map;

my $r = dclone(\@map);
tiltMap($r, 0);

printf "Part 1 result: %d\n", load($r);

$r = dclone(\@map);
my %cache = ( );
my $cycle = 0;

while(1) {

  # spin cycle
  for my $i (0..3) {
    tiltMap($r, $i);
  }
  $cycle++;

  my $c = compress($r);
  if(exists $cache{$c}) {
    # Found a cycle
    my $cycleLen = $cycle - $cache{$c};
    my $extraSteps = (1e9 - $cycle) % $cycleLen;

    # Do enough extra cycles so that the state will match the state after
    # cycle 1,000,000,000
    for my $i (1..$extraSteps) {
      for my $i (0..3) {
        tiltMap($r, $i);
      }
    }

    last;
  } else {
    $cache{$c} = $cycle;
  }
}

printf "Part 2 result: %d\n", load($r);

sub tiltMap {
  my ($r, $dir) = @_;
  my $ymax = $#$r;
  my $xmax = $#{$r->[0]};

  # These are the max x,y in the rotated coordinates
  my $ymax2 = ($dir == 0 || $dir == 1) ? $ymax : $xmax;
  my $xmax2 = ($dir == 0 || $dir == 1) ? $xmax : $ymax;

  my $mapX = sub {
    return $_[0] if $dir == 0;
    return $_[1] if $dir == 1;
    return $xmax - $_[0] if $dir == 2;
    return $ymax - $_[1] if $dir == 3;
  };

  my $mapY = sub {
    return $_[1] if $dir == 0;
    return $xmax - $_[0] if $dir == 1;
    return $ymax - $_[1] if $dir == 2;
    return $_[0] if $dir == 3;
  };

  # Iterate through all rows starting at the top
  for my $y (0..$ymax2) {
    # All cells in row
    for my $x (0..$xmax2) {
      # Convert coordinates
      my $mapy = $mapY->($x, $y);
      my $mapx = $mapX->($x, $y);

      # If this is a round boulder, move it up
      if($r->[$mapy]->[$mapx] eq 'O') {
        $r->[$mapy]->[$mapx] = '.';

        # Find the first row where this column is blocked
        my $row;
        for($row = $y - 1; $row >= 0; $row--) {
          last if $r->[$mapY->($x, $row)]->[$mapX->($x, $row)] ne '.';
        }

        # Place the boulder below that row
        $r->[$mapY->($x, $row + 1)]->[$mapX->($x, $row + 1)] = 'O';
      }
    }
  }
}

sub printMap {
  my $map = $_[0];
  for my $row (@$map) {
    print @$row, "\n";
  }
}

sub load {
  my $r = $_[0];
  my $load = 0;
  for my $y (0..$#$r) {
    my $count = 0;
    for my $ch (@{$r->[$y]}) {
      $count++ if $ch eq 'O';
    }
    $load += $count * (scalar(@$r) - $y);
  }
  return $load;
}

# Convert map into a compressed bit string representation
sub compress {
  my $map = $_[0];
  my $r = "";
  my $byte = 0;
  my $bit = 1;

  for my $y (0..$#$map) {
    for my $ch (@{$map->[$y]}) {
      $byte |= $bit if $ch eq 'O';
      if($bit == 0x80) {
        $r .= chr($byte);
        $byte = 0;
        $bit = 1;
      } else {
        $bit <<= 1;
      }
    }
  }

  $r .= chr($byte) if $bit != 1;
  return $r;
}
