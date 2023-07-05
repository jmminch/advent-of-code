# read and sort the input list.
my @adapters = <>;
chomp @adapters;
@adapters = sort { $a <=> $b } @adapters;

# add the outlet (a zero) and your device (3 + the max adapter output)
unshift @adapters, 0;
push @adapters, $adapters[-1] + 3;

for $idx (1..$#adapters) {
  $step1++ if ($adapters[$idx] - $adapters[$idx - 1] == 1);
  $step3++ if ($adapters[$idx] - $adapters[$idx - 1] == 3);
}

printf "part 1 result: %d\n", $step1 * $step3;

# count all valid combinations in the full list.
my $r = countPerm(0, $#adapters);
print "part 2 result: $r\n";
exit 0;

# part 2: process the list to find all sublists which are separated by a
# jump of 3.
# This is dead code. It turns out that this is an optimization that isn't
# needed.
my $nComb = 1;
my $idx = 0;
while($idx < $#adapters) {
  my $start = $idx;
  while($idx < $#adapters && $adapters[$idx + 1] - $adapters[$idx] < 3) {
    $idx++;
  }
  $nComb *= countPerm($start, $idx);
  $idx++;
}

print "part 2 result: $nComb\n";

# Count all valid combinations of adapter from start to end.
# This works by recursively calling itself to get the number of valid
# combinations if you skip 0, 1, or 2 entries after the start index.
sub countPerm {
  my ($start, $end) = @_;
  return 1 if $start == $end || $start == $end - 1;
  return 0 if $start > $end;
  return $cache{"$start.$end"} if exists $cache{"$start.$end"};
  my $r = countPerm($start + 1, $end);
  $r += countPerm($start + 2, $end) if $adapters[$start + 2] - $adapters[$start] <= 3;
  $r += countPerm($start + 3, $end) if $adapters[$start + 3] - $adapters[$start] <= 3;
  $cache{"$start.$end"} = $r;
  return $r;
}
