use strict vars;

# Read the map data
our @map = <>;
chomp @map;
@map = map { [ split //, $_ ] } @map;

# Count up the number of cells with active beams
printf "Part 1 result: %d\n", sim(-1, 0, 0);

# Now find the maximum number of energized cells for all possibilities
my $part2 = -1;

# Try horizontal beams
for my $y (0..$#map) {
  # beam from left edge
  my $r = sim(-1, $y, 0);
  $part2 = $r if $r > $part2;
  # beam from right edge
  $r = sim(scalar(@{$map[0]}), $y, 2);
  $part2 = $r if $r > $part2;
}
for my $x (0..$#{$map[0]}) {
  # beam from top edge
  my $r = sim($x, -1, 1);
  $part2 = $r if $r > $part2;
  # beam from bottom edge
  $r = sim($x, scalar(@map), 3);
  $part2 = $r if $r > $part2;
}

printf "Part 2 result: $part2\n";

sub sim {
  my ($sx, $sy, $sdir) = @_;

  # Bits in the beam map indicate which directions beams are travelling
  # when they enter this cell.
  my %beamMap;

  # x,y deltas for directions
  my @dirs = ( [1, 0], [0, 1], [-1, 0], [0, -1] );

  # Starting beam at (-1, 0) in direction 0
  my @beams = ( [$sx, $sy, $sdir] );

  while(my $beam = shift @beams) {
    my ($x, $y, $dir) = @$beam;
    
    # Move 1 square
    $x += $dirs[$dir]->[0];
    $y += $dirs[$dir]->[1];

    # check whether this is outside the map
    next if $x < 0 || $x > $#{$map[0]} || $y < 0 || $y > $#map;

    # check if there is a beam here in this direction already
    next if $beamMap{"$x,$y"} & (1 << $dir);

    # Add beam to beamMap
    $beamMap{"$x,$y"} |= 1 << $dir;

    # Add new beams to queue based on the contents of this cell.
    if($map[$y]->[$x] eq '.') {
      push @beams, [ $x, $y, $dir ];
    } elsif($map[$y]->[$x] eq '\\') {
      # Dirs 0/1 and 2/3 map to each other. Flip bit 0x1
      my $newDir = $dir ^ 0x1;
      push @beams, [ $x, $y, $newDir ];
    } elsif($map[$y]->[$x] eq '/') {
      # Dirs 0/3 and 1/2 map to each other. Flip both bits
      my $newDir = $dir ^ 0x3;
      push @beams, [ $x, $y, $newDir ];
    } elsif($map[$y]->[$x] eq '-') {
      if(!($dir & 1)) {
        # Beam is horizontal; just passes through the splitter
        push @beams, [ $x, $y, $dir ];
      } else {
        # Split into two horizontal beams
        push @beams, [ $x, $y, 0 ];
        push @beams, [ $x, $y, 2 ];
      }
    } elsif($map[$y]->[$x] eq '|') {
      if($dir & 1) {
        # Beam is vertical; just passes through the splitter
        push @beams, [ $x, $y, $dir ];
      } else {
        # Split into two vertical beams
        push @beams, [ $x, $y, 1 ];
        push @beams, [ $x, $y, 3 ];
      }
    }
  }

  return(scalar(keys %beamMap));
}
