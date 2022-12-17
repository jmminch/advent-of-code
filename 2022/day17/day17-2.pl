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
$nRock = 0;

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

  $nRock++;
}

# start by dropping 1000 rocks to get any pattern started.
for my $i (1..1000) {
  droprock();
}

# record the state of $sp, $ip; we're going to check for a pattern every
# time those values are reached.

$savedsp = $sp;
$savedip = $ip;

while(1) {
  if($sp == $savedsp && $ip == $savedip) {
    # count how many steps it takes for the next 10 rocks to come to rest.
    my $state = 0;
    for my $i (1..10) {
      $state <<= 5;
      my $r = droprock();
      $r = 0x1F if $r > 0x1F;
      $state |= $r;
    }

    # now check whether we've seen this state before.
    if(exists $cache{$state}) {
      my ($oldrocks, $oldheight) = @{$cache{$state}};
      print "Found loop! height = $oldheight after $oldrocks, and ",
            scalar @board, " after $nRock\n";

      # figure out how many more steps we need to simulate.
      my $totsteps = 1000000000000 - $nRock;
      my $loop = $nRock - $oldrocks;
      my $nLoop = int($totsteps / $loop);
      my $steps = $totsteps % $loop;
      my $heightPerLoop = scalar(@board) - $oldheight;

      print "Simulating $steps more steps.\n";

      for my $i (1..$steps) {
        droprock();
      }

      my $totheight = scalar @board + ($heightPerLoop * $nLoop);
      print "part 2 result: $totheight\n";
      last;
    } else {
      $cache{$state} = [ $nRock, scalar @board ];
    }
  } else {
    droprock();
  }
}
