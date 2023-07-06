# Offsets in the q,r,s space for directions on the hex grid. See
# https://www.redblobgames.com/grids/hexagons/ for details.
my %dirs = (
  n => [ 0, -1, 1 ],
  ne => [ 1, -1, 0 ],
  se => [ 1, 0, -1 ],
  s => [ 0, 1, -1 ],
  sw => [ -1, 1, 0 ],
  nw => [ -1, 0, 1 ] );

# input is a comma-separated list of directions
$_ = <>;
chomp;

my ($q, $r, $s);
my $part2 = 0;

for my $dir (split /,/) {
  my $delta = $dirs{$dir};
  $q += $delta->[0];
  $r += $delta->[1];
  $s += $delta->[2];

  # track maximum distance from origin
  my $dist = (abs($q) + abs($r) + abs($s)) / 2;
  $part2 = $dist if $dist > $part2;
}

printf "Part 1 result: %d\n", (abs($q) + abs($r) + abs($s)) / 2;
print "Part 2 result: $part2\n";
