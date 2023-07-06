my $start = <>;
my $line = <>;
my @buses = split /,/, $line;

# For part one, find t = (bus id) - (start % bus id) for each bus, and
# choose the minimum value for t.
my $mint = 9e12;
for $bus (@buses) {
  next if $bus eq 'x';
  my $t = $bus - ($start % $bus);
  $t = 0 if $t == $bus;
  if($t < $mint) {
    $mint = $t;
    $part1 = $mint * $bus;
  }
}

print "part 1 result: $part1\n";

# for part 2, we start by stepping forward in intervals of the first bus ID
# to find the first time that the first and second buses leave at the
# expected intervals. Then we increase the interval to LCM(bus ID 1, bus ID
# 2), since that pattern will repeat in that interval, and look for the
# first time that the third bus also leaves at the expected time. Repeat
# until you've found a time for all buses.
my $t = 0;
my $intv = $buses[0];
for $idx (1..$#buses) {
  next if $buses[$idx] eq 'x';
  while((($t + $idx) % $buses[$idx]) != 0) {
    $t += $intv;
  }
  $intv = lcm($intv, $buses[$idx]);
}

print "part 2 result: $t\n";

sub lcm {
  return $_[0] * ($_[1] / gcd($_[0], $_[1]));
}

# euclidian GCD algorithm, thanks wikipedia
sub gcd {
  return $_[0] if $_[1] == 0;
  return gcd($_[1], $_[0] % $_[1]);
}
