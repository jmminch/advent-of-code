use strict 'vars';
use Data::Dumper;

my $board = { };
my $fourD = 0;

# read the input state.
my $y = 0;
while(<>) {
  for my $x (0..(length($_) - 1)) {
    $board->{"$x,$y,0,0"} = 1 if substr($_, $x, 1) eq '#';
  }
  $y++;
}

my $tmpBoard = { (%$board) };
for my $i (1..6) {
  $tmpBoard = step($tmpBoard);
}

printf "part 1 result: %d\n", scalar keys %$tmpBoard;

$fourD = 1;
for my $i (1..6) {
  $board = step($board);
}

printf "part 2 result: %d\n", scalar keys %$board;

sub step {
  my $board = $_[0];
  my $newBoard = { };

  # loop through all active cells in the current board
  for my $coord (keys %$board) {
    my ($ax, $ay, $az, $aw) = split /,/, $coord;
    
    # check all adjacent cells to this one.
    for my $x ($ax-1 .. $ax+1) {
      for my $y ($ay-1 .. $ay+1) {
        for my $z ($az-1 .. $az+1) {
          # If fourD == 0, then only allow w to be 0
          for my $w ($aw-$fourD .. $aw+$fourD) {
          
            # skip processing if we've already looked at this coordinate.
            next if exists $newBoard->{"$x,$y,$z,$w"};

            my $count = countActive($board, $x, $y, $z, $w);
            if($count == 3 ||
               ($count == 2 && exists $board->{"$x,$y,$z,$w"})) {
              $newBoard->{"$x,$y,$z,$w"} = 1;
            } else {
              # This marks that this cell has been processed already. Zero
              # entries will get deleted before returning to the caller.
              $newBoard->{"$x,$y,$z,$w"} = 0;
            }

          }
        }
      }
    }
  }

  # Remove any marked inactive cells.
  for my $coord (keys %$newBoard) {
    delete $newBoard->{$coord} if !$newBoard->{$coord};
  }

  return $newBoard;
}

# Count all active cells in board adjacent to these coordinates.
sub countActive {
  my ($board, $cx, $cy, $cz, $cw) = @_;
  my $count = 0;
  for my $x ($cx-1 .. $cx+1) {
    for my $y ($cy-1 .. $cy+1) {
      for my $z ($cz-1 .. $cz+1) {
        for my $w ($cw-1 .. $cw+1) {
          $count++ if exists $board->{"$x,$y,$z,$w"};
        }
      }
    }
  }
  $count-- if exists $board->{"$cx,$cy,$cz,$cw"};
  return $count;
}
