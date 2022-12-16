# given a 2D map (a maze), find the shortest path, starting at '0', that
# passes through all cells with digits.

use Data::Dumper;

$minLength = (1 << 32);  # 32 bits is enough for anybody.
%cache = ( );  # cache of path lengths between points of interest.

# read the map
@map = ();
%points = ();
while(<>) {
  push @map, [ split(//, $_) ];

  # store away the location of any points of interest (digits)
  while(/(\d)/g) {
    $points{$1} = [ $-[0], $#map ];
  }
}

# a little weird because of how I want to use it. arguments are a list and
# an offset. This function will loop through all elements beginning with
# the offset, moving it to that offset, and then recursively call itself
# with offset + 1.
# If at the end of the list, then we've generated a new permutation; call
# the function to process this permutation.
sub permute {
  my ($list, $offset) = @_;

  if($offset == $#$list) {
    process($list);
  } else {
    # we're going to rotate the last n elements of the list n times, calling
    # permute each time. The last rotate will leave the list in its original
    # state when we return to the caller.
    for my $i ($offset..$#$list) {
      permute($list, $offset + 1);

      # rotate by removing the element at $offset and appending it.
      my $e = splice(@$list, $offset, 1);
      push @$list, $e;
    }
  }
}

# Given a list of point numbers (like [0, 1, 2...]), find the total
# distance. Track the shortest total distance found.
sub process {
  my $list = $_[0];
  my $total = 0;

  for $i (1..$#$list) {
    $total += pathlen($list->[$i - 1], $list->[$i]);
  }

  # for part 2, also include the distance from the last cell back to 0.
  if($part2) {
    $total += pathlen($list->[-1], 0);
  }

  $minLength = $total if $minLength > $total;
}

sub pathlen {
  # normalize the order of the inputs.
  my ($p0, $p1) = sort @_;

  return $cache{"$p0.$p1"} if exists $cache{"$p0.$p1"};

  # search for the shortest path from p0 -> p1.
  my @newsq = [ @{$points{$p0}} ];
  my $dist = 0;
  my @moves = ( [1,0], [-1,0], [0,1], [0,-1] );
  my %visited = ();

  LOOP: while(1) {

    # elements of newsq go into the list of points to search, start a new
    # list.
    my @sq = @newsq;
    @newsq = ();
    $dist++;

    for $sq (@sq) {
      # note that the map is surrounded by walls so I don't need to check
      # bounds.
      
      for $move (@moves) {
        my $newsq = [ $sq->[0] + $move->[0], $sq->[1] + $move->[1] ];
        next if exists $visited{"$newsq->[0].$newsq->[1]"}; # already checked this cell
        next if $map[$newsq->[1]]->[$newsq->[0]] eq '#'; # wall
        if($map[$newsq->[1]]->[$newsq->[0]] eq $p1) { # found goal
          $cache{"$p0.$p1"} = $dist;
          return $dist;
        }
        $visited{"$newsq->[0].$newsq->[1]"} = 1;
        push @newsq, $newsq;
      }
    }
  }
}

# this generates all permutations that and then calls 'process' for each one;
# process calculates path length and keeps track of the shortest total
# distance. Start the permutations at offset 1, since point 0 is always the
# starting point.
permute( [ sort keys %points ], 1);

print "part 1 result: $minLength\n";

# this tells the process function to do the part 2 calculation.
$part2 = 1;
$minLength = (1 << 32);

# the cache already built is still valid, no need to redo any pathfinding.

permute( [ sort keys %points ], 1);

print "part 2 result: $minLength\n";
