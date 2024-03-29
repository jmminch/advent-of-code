use strict vars;
use Storable qw(dclone);

# Read input into a 2D array of characters
my @map = <>;
chomp @map;
@map = map { [ split // ] } @map;

my $r = tiltMap(\@map, 0);

printf "Part 1 result: %d\n", load($r);

$r = dclone(\@map);
my %cache = ( );
my $cycle = 0;

while(1) {

  # spin cycle
  for my $i (0..3) {
    $r = tiltMap($r, $i);
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
        $r = tiltMap($r, $i);
      }
    }

    last;
  } else {
    $cache{$c} = $cycle;
  }
}

printf "Part 2 result: %d\n", load($r);

sub tiltMap {
  my ($map, $dir) = @_;
  my $r = dclone($map);

  if($dir == 0) {
    # Iterate through all rows starting at the top
    for my $y (0..$#$r) {
      # All cells in row
      for my $x (0..$#{$r->[$y]}) {

        # If this is a round boulder, move it up
        if($r->[$y]->[$x] eq 'O') {
          $r->[$y]->[$x] = '.';

          # Find the first row where this column is blocked
          my $row;
          for($row = $y - 1; $row >= 0; $row--) {
            last if $r->[$row]->[$x] ne '.';
          }

          # Place the boulder below that row
          $r->[$row + 1]->[$x] = 'O';
        }
      }
    }
  } elsif($dir == 2) {
    # Iterate through all rows starting at the bottom
    for my $y (reverse(0..$#$r)) {
      # All cells in row
      for my $x (0..$#{$r->[$y]}) {

        # If this is a round boulder, move it down
        if($r->[$y]->[$x] eq 'O') {
          $r->[$y]->[$x] = '.';

          # Find the first row where this column is blocked
          my $row;
          for($row = $y + 1; $row < scalar(@$r); $row++) {
            last if $r->[$row]->[$x] ne '.';
          }

          # Place the boulder above that row
          $r->[$row - 1]->[$x] = 'O';
        }
      }
    }
  } elsif($dir == 1) {
    # Iterate through all cols starting at the left
    for my $x (0..$#{$r->[0]}) {
      # All cells in col
      for my $y (0..$#$r) {

        # If this is a round boulder, move it left
        if($r->[$y]->[$x] eq 'O') {
          $r->[$y]->[$x] = '.';

          # Find the first col where this column is blocked
          my $col;
          for($col = $x - 1; $col >= 0; $col--) {
            last if $r->[$y]->[$col] ne '.';
          }

          # Place the boulder to the right of that col
          $r->[$y]->[$col + 1] = 'O';
        }
      }
    }
  } elsif($dir == 3) {
    # Iterate through all cols starting at the right
    for my $x (reverse(0..$#{$r->[0]})) {
      # All cells in col
      for my $y (0..$#$r) {

        # If this is a round boulder, move it right
        if($r->[$y]->[$x] eq 'O') {
          $r->[$y]->[$x] = '.';

          # Find the first col where this column is blocked
          my $col;
          for($col = $x + 1; $col < scalar @{$r->[$y]}; $col++) {
            last if $r->[$y]->[$col] ne '.';
          }

          # Place the boulder to the left of that col
          $r->[$y]->[$col - 1] = 'O';
        }
      }
    }
  }

  return $r;
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
