use Data::Dumper;

my $size = shift // 100;
my $steps = shift // 100;
my $size2 = $size + 2;

# The grid is 100x100. I will use a 102x102 board and leave the edges off,
# so that I don't need any special cases for finding neighbors at the edges.
@board = ('.') x $size2;
while(<>) {
  if(/(#|\.)/) {
    chomp;
    push @board, '.', split(//, $_), '.';
  }
}
push @board, ('.') x $size2;

my @initialState = @board; # make a copy of the initial state for part 2.

# run 100 steps.
for my $i (1..$steps) {
  step();
}

# count all 'on' cells.
my $count = 0;
for my $c (@board) {
  $count++ if $c eq '#';
}
print "part 1 result: $count\n";


# For part 2, repeat the simulation, but with the four corner cells "stuck"
# on.
@board = @initialState;
$board[$size2 + 1] = '#';               # (1,1)
$board[$size2 + $size] = '#';           # (100,1)
$board[$size * $size2 + 1] = '#';       # (1,100)
$board[$size * $size2 + $size] = '#';   # (100,100)


# run 100 steps.
for my $i (1..$steps) {
  step();
  $board[$size2 + 1] = '#';               # (1,1)
  $board[$size2 + $size] = '#';           # (100,1)
  $board[$size * $size2 + 1] = '#';       # (1,100)
  $board[$size * $size2 + $size] = '#';   # (100,100)
}

# count all 'on' cells.
$count = 0;
for my $c (@board) {
  $count++ if $c eq '#';
}
print "part 2 result: $count\n";

# simulate one step
sub step {
  # This is the list of offsets needed to find all the neighbors.
  my @n = (-$size2-1, -$size2, -$size2+1, -1, 1, $size2-1, $size2, $size2+1);

  # Changes are made on newBoard, and then it's copied over to board so that
  # all the changes happen at once.
  my @newBoard = @board;

  for my $y (1..$size) {
    for my $x (1..$size) {
      my $elem = $y * $size2 + $x;
      my $count = 0;
      for $offset (@n) {
        $count++ if $board[$elem + $offset] eq '#';
      }
      if($board[$elem] eq '#') {
        $newBoard[$elem] = '.' if $count < 2 || $count > 3;
      } else {
        $newBoard[$elem] = '#' if $count == 3;
      }
    }
  }

  @board = @newBoard;
}
