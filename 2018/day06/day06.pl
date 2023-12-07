use strict vars;
use List::Util qw(max);

# Threshold value for part 2
my $threshold = shift // 10000;

# Read the list of points. Determine the boundaries at the same time.
my @points;
my $minX = 9e100;
my $minY = 9e100;
my $maxX = -9e100;
my $maxY = -9e100;

while(<>) {
  if(/(\d+),\s*(\d+)/) {
    push @points, [ $1, $2 ];
    $minX = $1 if $1 < $minX;
    $minY = $2 if $2 < $minY;
    $maxX = $1 if $1 > $maxX;
    $maxY = $2 if $2 > $maxY;
  }
}

# Grow the boundary by one square
$minX--; $minY--; $maxX++; $maxY++;

# Iterate through all cells within the bounding rectangle and determine:
# 1. Which point is this cell closest to. Track the size of the region for
#    this point.
# 2. If this cell is on the boundary, then eliminate this cell's region from
#    consideration for part 1.
# 3. The total distance from this cell to all points. If it is less than the
#    threshold (default 10000) then increment the count for the size of the
#    region for part 2.
#
# Note that there's no need to actually store the map.

my $part2 = 0;
my %regions;

for my $x ($minX..$maxX) {
  for my $y ($minY..$maxY) {

    my $totalDist = 0;
    my $minDist = 9e100;
    my $minPoint = -1;
    for my $i (0..$#points) {
      my $p = $points[$i];
      my $dist = abs($p->[0] - $x) + abs($p->[1] - $y);
      $totalDist += $dist;
      if($dist < $minDist) {
        $minDist = $dist;
        $minPoint = $i;
      } elsif($dist == $minDist) {
        $minPoint = -1; # Used to indicate no "closest" point
      }
    }

    if($minPoint != -1 && $regions{$minPoint} != -1) {
      $regions{$minPoint}++;
    }
    if($minPoint != -1 && $x == $minX || $x == $maxX ||
                          $y == $minY || $y == $maxY) {
      # Region touches the border; mark it unusable for part 1.
      $regions{$minPoint} = -1;
    }

    $part2++ if $totalDist < $threshold;
  }
}

# Find the largest region
printf "Part 1 result: %d\n", max(values %regions);

print "Part 2 result: $part2\n";
