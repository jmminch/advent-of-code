use strict vars;

our @dirs = ( 1, 65536, -1, -65536 );
our %slopes = ( '>'=>1, '<'=>-1, '^'=>-65536, 'v'=>65536 );

# Read the input map
our @map = <>;
chomp @map;
my $sx = index($map[0], '.'); # find the '.' in the first row as the starting point
@map = map { [ split // ] } @map;

my %nodes;
my @nodeList = mkCoord($sx, 0);

# Build the map of all nodes (intersections) and their connections.
while(my $node = shift @nodeList) {
  next if exists $nodes{$node};
  $nodes{$node} = [ findAdjNodes($node) ];

  # Add any found nodes to the list of nodes to process.
  for my $x (@{$nodes{$node}}) {
    push @nodeList, $x->[0];
  }
}

# test code to print out the map.
if(0) {
  for my $node (sort keys %nodes) {
    my ($x, $y) = decCoord($node);
    print "($x, $y) => [";
    for my $z (@{$nodes{$node}}) {
      my ($x, $y) = decCoord($z->[0]);
      print " ($x, $y)$z->[1]";
      print "x" if !($z->[2]);
    }
    print " ]\n";
  }
}

my %visited = ( );
printf "Part 1 result: %d\n", longestPath(mkCoord($sx, 0), \%visited, 0);
%visited = ( );
printf "Part 2 result: %d\n", longestPath(mkCoord($sx, 0), \%visited, 1);

sub mkCoord {
  return ($_[0] + 0x8000) | (($_[1] + 0x8000) << 16)
}

sub decCoord {
  return (($_[0] & 0xffff) - 0x8000, ($_[0] >> 16) - 0x8000);
}

sub getAt {
  my ($x, $y) = decCoord($_[0]);
  return '#' if $x < 0 || $y < 0 || $y > $#map || $x > $#{$map[0]};
  return $map[$y]->[$x];
}

# Given a starting point, find all nodes (intersections) that are connected
# by a passage; the length of the passage; and any directional slope in the
# passage.
sub findAdjNodes {
  my $loc = $_[0];
  my @r;
  for my $dir (@dirs) {
    my ($adj, $dist, $slopeOk) = findAdjNode($loc, $dir);
    push @r, [ $adj, $dist, $slopeOk ] if $adj;
  }

  return @r;
}

# Given a starting point and direction, try to follow a path in that
# direction until finding another node.
sub findAdjNode {
  my ($loc, $dir) = @_;
  my $slopeOk = 1;
  my $dist = 1;

  # If the first step results in a bad position, bail out immediately.
  $loc += $dir;
  return undef if getAt($loc) eq '#';

  LOOP: while(1) {
    # If this is a node, bail out now.
    return ($loc, $dist, $slopeOk) if isNode($loc);

    # Check for an exit in any direction but the one we came from.
    for my $newDir (@dirs) {
      next if $newDir == -$dir;
      next if getAt($loc + $newDir) eq '#';

      # Figure out if this passage follows the slope.
      my $cur = getAt($loc);
      $slopeOk = 0 if exists($slopes{$cur}) and ($newDir != $slopes{$cur});

      # Move in this direction.
      $dir = $newDir;
      $loc += $dir;
      $dist++;
      next LOOP;
    }

    # No valid direction found; dead end.
    return undef;
  }
}

sub isNode {
  my ($x, $y) = decCoord($_[0]);
  return 1 if $y == 0 || $y == $#map;

  my $count = 0;
  for my $dir (@dirs) {
    $count++ if getAt($_[0] + $dir) ne '#';
  }

  return $count > 2;
}

sub longestPath {
  my ($startLoc, $visited, $part2) = @_;

  my ($x, $y) = decCoord($startLoc);
  return 0 if $y == $#map; # ending case

  my $maxLen = -1;

  $visited->{$startLoc} = 1;

  for my $z (@{$nodes{$startLoc}}) {
    next if $visited->{$z->[0]}; # skip already-visited nodes.
    next if !$part2 and !$z->[2]; # skip for part 1 if slopeOk is not set
    my $r = longestPath($z->[0], $visited, $part2);
    if($r != -1) {
      $r += $z->[1];
      $maxLen = $r if $maxLen < $r;
    }
  }

  $visited->{$startLoc} = 0;

  return $maxLen;
}
