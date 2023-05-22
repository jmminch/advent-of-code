# Read the input into a two-dimensional array.
our @board;
while(<>) {
  chomp;
  push @board, [ split // ];
}

# Find the starting point.
my ($x, $y, $face) = (0, -1, 0);
for ($x = 0; $x <= $#{$board[0]}; $x++) {
  last if $board[0]->[$x] eq '|';
}

# delta values for directions, starting with down and going clockwise.
our @dirs = ( [0,1], [-1,0], [0,-1], [1,0] );

my $part1 = "";
my $part2 = 0;

while(1) {
  # Try moving straight.
  if(getAtDir($x, $y, $face) ne ' ') {
    # nothing
  } elsif(getAtDir($x, $y, $face - 1) ne ' ') {
    # Turn left
    $face--;
  } elsif(getAtDir($x, $y, $face + 1) ne ' ') {
    # Turn right
    $face++;
  } else {
    # End point
    last;
  }

  $face %= 4;
  $x += $dirs[$face]->[0];
  $y += $dirs[$face]->[1];

  $part1 .= $board[$y]->[$x] if $board[$y]->[$x] =~ /[A-Z]/;
  $part2++;
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

# Increment position based on dir and return what is on the board at that
# poisition.
sub getAtDir {
  $_[2] %= 4; # normalize direction
  my $x = $_[0] + $dirs[$_[2]]->[0];
  my $y = $_[1] + $dirs[$_[2]]->[1];
  my $r = $board[$y]->[$x];
  return ($r eq undef) ? ' ' : $r;
}
