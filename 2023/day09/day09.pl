use strict vars;

my $part1 = 0;
my $part2 = 0;
while(<>) {
  my @vals = split /\s+/;
  $part1 += nextVal(\@vals);
  $part2 += prevVal(\@vals);
}
print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub nextVal {
  my $vals = $_[0];
  return 0 if scalar @$vals < 2;
  my $diffVals = diffVals($vals);
  return $vals->[-1] + nextVal($diffVals);
}

sub prevVal {
  my $vals = $_[0];
  return 0 if scalar @$vals < 2;
  my $diffVals = diffVals($vals);
  return $vals->[0] - prevVal($diffVals);
}

sub diffVals {
  my $vals = $_[0];
  my @diff;
  for my $i (1..$#$vals) {
    $diff[$i - 1] = $vals->[$i] - $vals->[$i - 1];
  }
  return \@diff;
}
