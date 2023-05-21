# The board is a 6 row x 50 column grid.
our @board;
for my $i (1..6) {
  push @board, [ (0) x 50 ];
}

while(<>) {
  if(/rect (\d+)x(\d+)/) {
    # turn on a WxH rectangle of pixels starting at (0,0)
    for my $x (1..$1) {
      for my $y (1..$2) {
        $board[$y-1]->[$x-1] = 1;
      }
    }
  } elsif(/rotate row y=(\d+) by (\d+)/) {
    # rotate row right.
    my @row;
    for my $x (0..49) {
      push @row, $board[$1]->[(50 - $2 + $x) % 50];
    }
    for my $x (0..49) {
      $board[$1]->[$x] = $row[$x];
    }
  } elsif(/rotate column x=(\d+) by (\d+)/) {
    # rotate column down.
    my @column;
    for my $y (0..5) {
      push @column, $board[(6 - $2 + $y) % 6]->[$1];
    }
    for my $y (0..5) {
      $board[$y]->[$1] = $column[$y];
    }
  }
}

# count all set cells
my $part1 = 0;
for my $row (@board) {
  for my $cell (@$row) {
    $part1++ if $cell;
  }
}

print "Part 1 result: $part1\n";

# print the contents of the board
print "Part 2 result:\n";
for my $row (@board) {
  print join '', map { $_ ? '#' : ' ' } @$row;
  print "\n";
}
