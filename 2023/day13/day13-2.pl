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
  my $r = reflect(\@map, 1, ($r1 > 99 ? ($r1 / 100) : undef));
  if($r > 0) {
    $part2 += $r * 100;
    next LOOP;
  }
      
  # Check for a horizontal reflection.
  my $r = reflect(\@cols, 1, ($r1 < 100 ? $r1 : undef));
  if($r > 0) {
    $part2 += $r;
    next LOOP;
  }

  die("No reflection found.");
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub reflect {
  my @map = @{$_[0]};
  my $pt2 = $_[1];
  my $skip = $_[2];

  # Look for identical rows
  my %rLines = ( );
  for my $y1 (0..($#map - 1)) {
    # Since the reflection line is between two rows, only need to check
    # every other row.
    for(my $y2 = $y1 + 1; $y2 <= $#map; $y2 += 2) {
      # Calculate potential line for reflection
      my $yr = ($y1 + int(($y2 - $y1) / 2) + 1);

      # The answer for part 2 cannot be the same as the answer for part 1
      next if $yr == $skip;

      if($map[$y1] eq $map[$y2]) {
        $rLines{$yr}++;
      } elsif($pt2) {
        # Check whether the two differ by exactly one character
        my $dc = 0;
        for my $x (0..(length($map[$y1]) - 1)) {
          $dc++ if substr($map[$y1], $x, 1) ne substr($map[$y2], $x, 1);
          last if $dc > 1;
        }
        if($dc == 1) {
          my $yr = ($y1 + int(($y2 - $y1) / 2) + 1);
          $rLines{$yr} += 1001;
        }
      }
    }
  }

  # For every potential reflection line found, determine how many rows would
  # have to be identical.
  for my $yr (keys %rLines) {
    my $ncmp = scalar(@map) - $yr;
    $ncmp = $yr if $yr < $ncmp;

    # For part 1, the counted lines should be == $ncmp.
    # For part 2, we added 1000 for the line that was different by one
    # character, and so the counted lines should be == 1000 + $ncmp
    return $yr if $rLines{$yr} == (($pt2) ? $ncmp + 1000 : $ncmp);
  }

  # no reflections
  return -1;
}
