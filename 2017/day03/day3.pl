use POSIX qw(ceil);

my $input = shift // 312051;

# Part 1: find the manhattan distance to cell $input
# See the notes for details.

my $n = ceil(sqrt($input));
$n++ if ($n & 1) == 0; # Round up even numbers.
my $ds = (($n - 1) / 2);
my $p = ($input - (($n - 2) * ($n - 2) + 1)) % ($n - 1);
my $dc = abs(($n - 3) / 2 - $p);
printf "Part 1 result: %d\n", $ds + $dc;


# Part 2: visit each cell in order, setting the value of each to the sum of
# the values of all adjacent filled squares.

my $x = 0;
my $y = 0;
my $face = 0;  # facing direction
my $dist = 0.5; # start by walking this far.

my @dirs = ( [0,1], [-1,0], [0,-1], [1,0] );
my @adj = ( [-1,-1], [0,-1], [1,-1], [-1,0], [1,0], [-1,1], [0,1], [1,1] );

my %map = ( "0,0" => 1 );

while(1) {
  # walk in a straight line for dist squares.
  # Note that dist may be a fraction, in which case that will be rounded
  # up, which is what we want.
  for(my $i = 0; $i < $dist; $i++) {

    # take one step
    $x += $dirs[$face]->[0];
    $y += $dirs[$face]->[1];

    # Calculate the sum of all adjacent squares.
    my $s = 0;
    for my $a (@adj) {
      $s += $map{($x + $a->[0]) . "," . ($y + $a->[1])};
    }
    $map{"$x,$y"} = $s;
    if($s > $input) {
      print "Part 2 result: $s\n";
      exit 0;
    }
  }

  # Turn and increase distance by 0.5 (so every two loops we start going
  # further.)
  $face++;
  $face = 0 if $face > 3;

  # possible problem with this -- floating point inaccuracy.
  $dist += 0.5;
}
