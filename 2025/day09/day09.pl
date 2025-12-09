use strict vars;
use Data::Dumper;

my @points;
my (@vEdge, @hEdge);

while(<>) {
  push @points, [ $1, $2 ] if /(\d+),(\d+)/;
}

# Create a list of all the edges.
for my $i (0..$#points) {
  my $v1 = $points[$i];
  my $v2 = $points[$i == $#points ? 0 : $i + 1];

  if($v1->[0] == $v2->[0]) {
    if($v1->[1] < $v2->[1]) {
      push @vEdge, [ $v1->[0], $v1->[1], $v2->[1] ];
    } else {
      push @vEdge, [ $v1->[0], $v2->[1], $v1->[1] ];
    }
  } else {
    if($v1->[0] < $v2->[0]) {
      push @hEdge, [ $v1->[1], $v1->[0], $v2->[0] ];
    } else {
      push @hEdge, [ $v1->[1], $v2->[0], $v1->[0] ];
    }
  }
}

@vEdge = sort { $a->[0] <=> $b->[0] } @vEdge;
@hEdge = sort { $a->[0] <=> $b->[0] } @hEdge;

# Try every rectangle that can be formed from two vertices.

my $part1 = 0;
my $part2 = 0;

for my $i (0..$#points-1) {
  LOOP: for my $j ($i+1..$#points) {
    my $xr = ($points[$i]->[0] < $points[$j]->[0]) ?
             [ $points[$i]->[0], $points[$j]->[0] ] : 
             [ $points[$j]->[0], $points[$i]->[0] ];
    my $yr = ($points[$i]->[1] < $points[$j]->[1]) ?
             [ $points[$i]->[1], $points[$j]->[1] ] : 
             [ $points[$j]->[1], $points[$i]->[1] ];

    my $area = ($xr->[1] - $xr->[0] + 1) *
               ($yr->[1] - $yr->[0] + 1);
    $part1 = $area if $area > $part1;

    next if $area < $part2;

    # Check whether any other edge overlaps this rectangle.
    for my $e (@vEdge) {
      # Todo -- would be faster to do a binary search
      next if $e->[0] <= $xr->[0];
      last if $e->[0] >= $xr->[1];
      next LOOP if overlap($yr->[0], $yr->[1], $e->[1], $e->[2]);
    }
    for my $e (@hEdge) {
      # Todo -- would be faster to do a binary search
      next if $e->[0] <= $yr->[0];
      last if $e->[0] >= $yr->[1];
      next LOOP if overlap($xr->[0], $xr->[1], $e->[1], $e->[2]);
    }


    # No overlap
    $part2 = $area if $area > $part2;
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub overlap {
  my ($x1, $x2, $y1, $y2) = @_;
  ($x1,$x2) = ($x2,$x1) if $x1 > $x2;
  ($y1,$y2) = ($y2,$y1) if $y1 > $y2;
  return ($x2 >= $y1 && $x1 <= $y2);
}
