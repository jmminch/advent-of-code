use strict vars;

my $part1 = 0;
my $part2 = 0;

# Set paragraph mode to read one map at a time.
$/ = "";
LOOP: while(<>) {
  # Remember the result for part 1, since in part 2 the answer is required
  # to be a different line.
  my $r1;
  my @map = split /\n/;

  # Build a set of strings representing the columns.
  my @cols;
  for my $line (@map) {
    my @chars = split //, $line;
    for my $i (0..$#chars) { $cols[$i] .= $chars[$i] }
  }

  # Check for a vertical reflection.
  my $r = reflect(\@map);
  if($r > 0) {
    $r1 = $r * 100;
    $part1 += $r1;
    goto PART2;
  }

  # Check for horizontal reflection
  $r = reflect(\@cols);
  if($r > 0) {
    $r1 = $r;
    $part1 += $r1;
    goto PART2;
  }

  die("No reflection found.");

  PART2:

  # Check for vertical reflection, part 2
  for my $y (0..$#map) {
    for my $x (0..(length($map[0]) - 1)) {
      # Flip the character at (x,y)
      my $ch = substr($map[$y], $x, 1);
      my $newch = ($ch eq '#') ? '.' : '#';
      substr($map[$y], $x, 1) = $newch;
      
      # Check for a vertical reflection.
      my $r = reflect(\@map, ($r1 > 99 ? ($r1 / 100) : undef));
      if($r > 0) {
        $part2 += $r * 100;
        next LOOP;
      }

      # Restore the character that was flipped
      substr($map[$y], $x, 1) = $ch;
    }
  }

  # Check for horizontal reflection, part 2
  for my $y (0..$#cols) {
    for my $x (0..(length($cols[0]) - 1)) {
      my $ch = substr($cols[$y], $x, 1);
      my $newch = ($ch eq '#') ? '.' : '#';
      substr($cols[$y], $x, 1) = $newch;
      
      # Check for a horizontal reflection.
      my $r = reflect(\@cols, ($r1 < 100 ? $r1 : undef));
      if($r > 0) {
        $part2 += $r;
        next LOOP;
      }

      substr($cols[$y], $x, 1) = $ch;
    }
  }


  die("No reflection found.");
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub reflect {
  my $rows = $_[0];
  LOOP: for my $row (1..$#$rows) {
    # when $row is 1, the dividing line is between rows 0 and 1
    next if defined($_[1]) && $row == $_[1];

    # The number of rows to compare
    my $ncmp = $#$rows - $row + 1;
    $ncmp = $row if $row < $ncmp;

    for my $i (0..($ncmp - 1)) {
      next LOOP if $rows->[$row - $i - 1] ne $rows->[$row + $i];
    }

    # found a reflection
    return $row;
  }

  # no reflections
  return -1;
}
