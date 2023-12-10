use strict vars;
use Data::Dumper;

# Read the map
our @map = map { chomp; [ split // ]; } <>;
our @fillMap; # map used for part 2

# Directions
our @dirs = ([-1,0],[0,1],[1,0],[0,-1]);

# Pipe sections. Set bits indicate that there is a pipe exit in that
# direction (so if bit 0 (1) is set, there is an exit up)
our %pipes = ( '|'=>5, '-'=>10, 'L'=>3, 'J'=>9, '7'=>12, 'F'=>6, 'S'=>-1 );

# Convert the map to the above representation. Also find the starting point.
my ($sx, $sy);
LOOP: for my $y (0..$#map) {
  for my $x (0..$#{$map[$sy]}) {
    $map[$y]->[$x] = $pipes{get($y, $x)};
    if(get($y, $x) == -1) {
      $sx = $x; $sy = $y;
    }
  }
}

# Determine the pipe section at the starting point.
my $startPipe = 0;
my $sDir = 0;
for my $dir (0..$#dirs) {
  # pipe section in this direction
  my $pipe = get($sy + $dirs[$dir]->[0], $sx + $dirs[$dir]->[1]);
  # determine if the pipe has an exit going back in the opposite dir
  if($pipe & (1 << (($dir + 2) % 4))) {
    $startPipe |= 1 << $dir;
    $sDir = $dir; # starting dir will end up being the last one found.
  }
}
$map[$sy]->[$sx] = $startPipe;

# Follow the path of the pipe until getting back to the start.
my $pathLen = 0;
my $x = $sx;
my $y = $sy;
do {
  # Move the pointer in the current direction.
  $y += $dirs[$sDir]->[0];
  $x += $dirs[$sDir]->[1];
  $pathLen++;

  # Based on the pipe under this point, turn to the correct new direction.
  my $pipe = get($y, $x);
  for my $newDir (0...$#dirs) {
    next if $newDir == ($sDir + 2) % 4;  # Can't turn around
    if($pipe & (1 << $newDir)) {
      $sDir = $newDir;
      last;
    }
  }

  # Put a '#' at the appropriate location in fillMap.
  my $fx = 1 + 2 * $x;
  my $fy = 1 + 2 * $y;
  $fillMap[$fy]->[$fx] = '#';
  for my $dir (0..$#dirs) {
    if($pipe & (1 << $dir)) {
      $fillMap[$fy + $dirs[$dir]->[0]]->[$fx + $dirs[$dir]->[1]] = '#';
    }
  }
  
} while($x != $sx || $y != $sy);

# Part 1 result is half of the total length of the loop.
printf "Part 1 result: %d\n", $pathLen / 2;

# Do a flood fill starting at (0,0)
my @cells = ( [0,0] );
while(my $cell = shift @cells) {
  my $y = $cell->[0];
  my $x = $cell->[1];
  next if get2($y, $x) eq '#';
  $fillMap[$y]->[$x] = '#';
  for my $dir (@dirs) {
    push @cells, [ $y + $dir->[0], $x + $dir->[1] ];
  }
}

# Look for any cells corresponding to original map cells that aren't filled.
my $part2 = 0;
for my $y (0..$#map) {
  for my $x (0..$#{$map[$y]}) {
    my $fx = 1 + 2 * $x;
    my $fy = 1 + 2 * $y;
    $part2++ if get2($fy, $fx) ne '#';
  }
}

print "Part 2 result: $part2\n";

# Get the pipe segment at (y,x)
sub get {
  return 0 if $_[0] < 0 || $_[0] > $#map ||
              $_[1] < 0 || $_[1] > $#{$map[$_[0]]}; 
  return $map[$_[0]]->[$_[1]];
}

# Get the cell in fillMap at (y,x)
sub get2 {
  my $fh = 2 * scalar(@map) + 1;
  my $fw = 2 * scalar(@{$map[0]}) + 1;
  return '#' if $_[0] < 0 || $_[0] >= $fh ||
                $_[1] < 0 || $_[1] >= $fw;
  return $fillMap[$_[0]]->[$_[1]];
}
