# the input is a string of ^,v,<,>, representing moves on a 2d plane.
# the object is to determine how many squares were visited, including the
# starting point.

# locations are represented as 0xYYYYXXXX
$loc = 0x80008000;

my %visited = ( $loc => 1 );# remember that the starting point has been visited.

# each character is mapped to a value to add to loc to move that direction.
%dirs = ( '^' => -65536, 'v' => 65536, '<' => -1, '>' => 1 );

$moves = <>;
# loop through each char
for my $c (split //, $moves) {
  # move to next location
  $loc += $dirs{$c} if exists $dirs{$c};
  # mark this location
  $visited{$loc} = 1;
}

print "part 1 result: ", scalar keys %visited, "\n";

# start over for part 2.  This time we've got two things moving in parallel,
# so keep track of 2 locations.  They take turns moving, but still based on
# the same set of instructions.

my @loc = ( 0x80008000, 0x80008000 );
# reset the visited map
%visited = ( 0x80008000 => 1 );
my $idx = 0;  # will flip between 0 and 1

# loop through each char
for my $c (split //, $moves) {
  next if !exists $dirs{$c};
  # move to next location
  $loc[$idx] += $dirs{$c};
  # mark this location
  $visited{$loc[$idx]} = 1;
  
  $idx = !$idx;  # flip to using the other loc
}

print "part 2 result: ", scalar keys %visited, "\n";

