use Data::Dumper;

# The string representing rock movements.
$input = <>;
$input =~ s/[^<>]//g;

# The shapes are one byte per row; first byte is the top row and 0x80 is
# the leftmost cell.
@shapes = ( 0x3C000000, 0x10381000, 0x08083800, 0x20202020, 0x30300000 );

@board = ();

$ip = 0; # pointer into $input
$sp = 0; # pointer into @shapes

sub droprock {
  # Get the next rock from the list of shapes.
  my $shape = $shapes[$sp];
  $sp++;
  $sp = 0 if $sp > $#shapes;

  # Find its starting position. The bottom edge should be 3 units above the
  # top of the board. pos is the position of the bottom row of the shape.
  my $pos = scalar @board + 3; # 3 units of space
  
  # decrement pos by the number of empty rows at the bottom of this shape.
  for my $i (0..3) {
    last if (($shape >> ($i * 8)) & 0xFF);
    $pos--;
  }

  # move the rock until it can't move down.
  while(1) {
    
    # get the next horizontal motion
    my $h = substr $input, $ip, 1;
    $ip++;
    $ip = 0 if $ip >= length $input;

    my $newshape;
    if($h eq '<') {
      $newshape = $shape << 1;
    } else {
      $newshape = $shape >> 1;
    }

    # If any 1 bits are set, then this motion would have hit a wall.
    if(!($newshape & 0x0101010101)) {
      
      # now check whether this new shape overlaps with any lines on the
      # board (sideways motion blocked by another shape).
      my $blocked = 0;
      for my $i (0..3) {
        next if $pos + $i < 0;
        if($board[$pos + $i] & ((($newshape >> (8 * $i))) & 0xFF)) {
          $blocked = 1;
          last;
        }
      }

      $shape = $newshape if !$blocked;
    }

    # check if the rock can move down.
    my $blocked = 0;

    # check whether there's a non-empty row at the level of the floor.
    if($pos < 1) {
      if(($shape >> (8 * (-$pos))) & 0xFF) {
        $blocked = 1;
      }
    }

    if(!$blocked) {
      # check whether there's a collision at pos - 1.
      for my $i (0..3) {
        if((($shape >> ($i * 8)) & 0xFF) & $board[$pos - 1 + $i]) {
          $blocked = 1;
          last;
        }
      }
    }

    # If downward motion is blocked, then place this block on the board.
    if($blocked) {
      for my $i (0..3) {
        next if $pos + $i < 0;
        $board[$pos + $i] |= ($shape >> ($i * 8)) & 0xFF;
      }
      last;
    }

    $pos--;
  }
}

for my $i (1..2022) {
  droprock();
}

print "part 1 result: ", scalar @board, "\n";
