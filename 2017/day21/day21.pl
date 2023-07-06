use Data::Dumper;

# read input rules.
while(<>) {
  if(/([\.#\/]+) => ([\.#\/]+)/) {
    $rules{encode($1)} = $2;
  }
}

my $board = [ ".#.", "..#", "###" ];

for my $i (1..5) {
  $board = enhance($board);
}

# count number of '#' squares.
printf "Part 1 result: %d\n", countOn($board);

for my $i (1..13) {
  $board = enhance($board);
}

# count number of '#' squares.
printf "Part 2 result: %d\n", countOn($board);

# Encode a 2x2 or 3x3 tile.
# Input is in the format .../.../... or ../..
sub encode {
  my @rows = split /\//, $_[0];
  my $size = length $rows[0];
  my $minEncode = 0xFFFF;
  my @forward = (0..$size - 1);
  my @reverse = reverse @forward;

  # rows first, then columns
  for $rowRange (\@forward, \@reverse) {
    for $colRange (\@forward, \@reverse) {

      my $tmp = 0;
      for my $y (@$rowRange) {
        for my $x (@$colRange) {
          $tmp <<= 1;
          $tmp |= 1 if substr($rows[$y], $x, 1) eq '#';
        }
      }
      $minEncode = $tmp if $tmp < $minEncode;

    }
  }

  # columns first, then rows
  for $colRange (\@forward, \@reverse) {
    for $rowRange (\@forward, \@reverse) {

      my $tmp = 0;
      for my $x (@$colRange) {
        for my $y (@$rowRange) {
          $tmp <<= 1;
          $tmp |= 1 if substr($rows[$y], $x, 1) eq '#';
        }
      }
      $minEncode = $tmp if $tmp < $minEncode;

    }
  }

  return $size * 0x10000 + $minEncode;
}

sub enhance {
  # Determine if input needs to be split into 2x2 or 3x3 tiles
  my $tileSize = 2;
  if(length($_[0]->[0]) & 1) {
    # 3x3 tiles.
    $tileSize = 3;
  }

  my $output = [ ];
  my ($x, $y, $outRow);

  for($x = 0; $x < length($_[0]->[0]); $x += $tileSize) {
    for($y = 0, $outRow = 0; $y < length($_[0]->[0]); $y += $tileSize) {
      # encode the tile at x, y
      my $tile = join "/",
              map { substr($_[0]->[$y + $_], $x, $tileSize) } (0..$tileSize - 1);
      my $tileId = encode($tile);

      my $enhancedTile = $rules{$tileId};
      my @rows = split '/', $enhancedTile;

      for my $row (@rows) {
        $output->[$outRow] .= $row;
        $outRow++;
      }
    }
  }

  return $output;
}

sub countOn {
  my $r = 0;
  for my $row (@{$_[0]}) {
    for my $i (0..length($row) - 1) {
      $r++ if substr($row, $i, 1) eq '#';
    }
  }
  return $r;
}
