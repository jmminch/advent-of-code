use Data::Dumper;

# 1. read the map.

for(my $y = 0; <>; $y++) {
  for(my $x = index($_, '#'); $x >= 0; $x = index($_, '#', $x + 1)) {
    $elves{"$x.$y"} = { };
  }
}

# 2. Set initial direction list.

my @dirs = ( [0,-1], [0,1], [-1,0], [1,0] );

# For each dir, this is a list of the tiles to consider before allowing a
# move in that direction.
my @diradj = ( [ [-1,-1],[0,-1],[1,-1] ],
               [ [-1,1],[0,1],[1,1] ],
               [ [-1,-1],[-1,0],[-1,1] ],
               [ [1,-1],[1,0],[1,1] ] );

# All adjacent squares.
my @adj = ( [-1,-1], [0,-1], [1,-1], [-1,0], [1,0], [-1,1], [0,1], [1,1] );

my $minx, $maxx, $miny, $maxy;

my $part1 = -1;
my $rounds = 0;

# 3. Move until we're done
while(1) {

  #printMap();
  #print("\n---\n\n");

  # how many elves were found to be adjacent to others this round.
  my $adjacent = 0;

  $minx = $miny = 999999;
  $manx = $maxy = -999999;

  # 3.1 Set a new location for each elf.
  for my $e (keys %elves) {
    my ($x, $y) = split /\./, $e;

    # track bounding rect.
    $minx = $x if $x < $minx;
    $miny = $y if $y < $miny;
    $maxx = $x if $x > $maxx;
    $maxy = $y if $y > $maxy;

    # check whether there are any elves in adjacent squares.
    my $anyAdjacent = 0;
    for my $a (@adj) {
      my $nx = $x + $a->[0];
      my $ny = $y + $a->[1];
      if(exists $elves{"$nx.$ny"}) {
        $anyAdjacent = 1;
        last;
      }
    }
    next if !$anyAdjacent;

    $adjacent++;
    
    for(my $dir = 0; $dir <= $#dirs; $dir++) {
      # check all three squares in loc + diradj[$dir]
      my $moveok = 1;
      for my $adj (@{$diradj[$dir]}) {
        my $nx = $x + $adj->[0];
        my $ny = $y + $adj->[1];
        if(exists $elves{"$nx.$ny"}) {
          $moveok = 0;
          last;
        }
      }

      # Nothing in those three squares; use this direction as the potential
      # move.
      if($moveok) {
        my $nx = $x + $dirs[$dir]->[0];
        my $ny = $y + $dirs[$dir]->[1];
        $elves{$e}->{next} = "$nx.$ny";
        last;
      }
    }

  }

  # part 1 ends after 10 rounds or no more work is to be done.
  if($part1 == -1 && ($rounds == 10 || !$adjacent)) {
    # Calculate the number of empty tiles.
    $part1 = (($maxx - $minx + 1) * ($maxy - $miny + 1)) - (scalar keys %elves);
    print "part 1 result: $part1\n";
  }

  # If no elves are adjacent to each other, quit.
  last if !$adjacent;

  # 3.2 Find any elves that have the same "next" location and clear those.
  my @elfList = keys %elves;
  for my $i (0..$#elfList) {
    my $next = $elves{$elfList[$i]}->{next};
    next if !defined $next;

    for my $j (($i+1)..$#elfList) {
      if($next eq $elves{$elfList[$j]}->{next}) {
        delete $elves{$elfList[$i]}->{next};
        delete $elves{$elfList[$j]}->{next};
      }
    }
  }

  # 3.3 Move all elves to new location. After this loop is over, no elves
  # will have a "next" field set.
  for $e (@elfList) {
    my $elf = $elves{$e};
    if(exists $elf->{next}) {
      delete $elves{$e};
      $elves{$elf->{next}} = { };
    }
  }

  # 3.4 Rotate the direction lists.
  my $d = splice @dirs, 0, 1;
  push @dirs, $d;
  $d = splice @diradj, 0, 1;
  push @diradj, $d;

  $rounds++;
}

# 1-based.
$rounds++;
print "part 2 result: $rounds\n";

sub printMap {
  # find min and max coordinates. 
  my $minx = $miny = 999999;
  my $maxx = $maxy = -999999;
  for $e (keys %elves) {
    my ($x, $y) = split /\./, $e;
    $minx = $x if $x < $minx;
    $miny = $y if $y < $miny;
    $maxx = $x if $x > $maxx;
    $maxy = $y if $y > $maxy;
  }

  # loop through all squares.
  for my $y ($miny..$maxy) {
    for my $x ($minx..$maxx) {
      if(exists $elves{"$x.$y"}) {
        print '#';
      } else {
        print '.';
      }
    }
    print "\n";
  }
}
