#!/usr/bin/perl

use strict vars;
use Data::Dumper;

my @points;

while(<>) {
  push @points, [ $1, $2 ] if /(\d+),(\d+)/;
}

# Calculate the area of the rectangle formed by each pair of points and
# determine the largest area.
my $part1 = 0;
for my $i (0..$#points-1) {
  for my $j ($i+1..$#points) {
    my $area = (1 + abs($points[$i]->[0] - $points[$j]->[0])) *
               (1 + abs($points[$i]->[1] - $points[$j]->[1]));
    $part1 = $area if $area > $part1;
  }
}

print "Part 1 result: $part1\n";

# The tiles form the corners of a polygon with horizontal and vertical
# sides. Process the list of points to generate the locations of the
# vertices, as well as information about the direction of each edge and the
# concavity of each vertex.
#
our @vertex;
our $xfDir = 0;
our @xfOrigin = ( 0, 0 );

for my $i (0..$#points) {
  my $v = [$points[$i]->[0], $points[$i]->[1], 0, 0];

  my $p0 = $i == 0 ? $#points : $i - 1;
  my $p1 = $i;
  my $p2 = $i == $#points ? 0 : $i + 1;

  my $d0 = dir($points[$p0], $points[$p1]);
  my $d1 = dir($points[$p1], $points[$p2]);
  
  $v->[2] = $d1;  # Direction of edge
  $v->[3] = (($d0 + 1) % 4) == $d1;  # True if convex

  # Adjust the coordinates appropriately to find the vertex locations.
  if($d1 == 0) {
    $v->[0]++ if !$v->[3];
  } elsif($d1 == 1) {
    $v->[0]++;
    $v->[1]++ if !$v->[3];
  } elsif($d1 == 2) {
    $v->[1]++;
    $v->[0]++ if $v->[3];
  } elsif($d1 == 3) {
    $v->[1]++ if $v->[3];
  }

  push @vertex, $v;
}

# See notes for details on the algorithm.
my $part2 = 0;

for my $i (0..$#vertex) {
  # Set transformation parameters for this vertex.
  @xfOrigin = @{$vertex[$i]};
  $xfDir = $vertex[$i]->[2];

  # Skip concave vertices.
  next if !($vertex[$i]->[3]);

  # Find the nearest edge that crosses V=0, with positive U. Note
  # that such an edge *must* be downward.
  my $U = 999999999;
  for my $j (0..$#vertex) {
    my $v0 = Point($j);
    my $v1 = Point($j + 1);

    # Check direction
    next if dir($v0, $v1) != 1;

    # Check positive U
    next if $v0->[0] < 0;

    # Check that we haven't already found one closer.
    next if $v0->[0] >= $U;

    # Check that it crosses/touches the U-axis and extends below it.
    next if $v0->[1] > 0 || $v1->[1] <= 0;

    $U = $v0->[0];
  }

  my $V = 0;

  while($U > 0) {
    # Find the nearest edge below V, that overlaps with (0,U)
    # This edge *must* be leftward.
    my $Vnew = 999999999;
    my $Unew = 999999999;

    for my $j (0..$#points) {
      my $v0 = Point($j);
      my $v1 = Point($j + 1);

      # Check direction
      next if dir($v0, $v1) != 2;

      # Check that the V-coordinate is between V and the minimum found so
      # far. 
      next if $v0->[1] <= $V;
      next if $v0->[1] > $Vnew;

      # There may be two edges at the same V. Pick the one that has the
      # smallest U.
      if($v0->[1] == $Vnew) {
        next if $v1->[0] > $Unew;
      }

      # Check whether it overlaps with (0, U)
      next if $v0->[0] <= 0 || $v1->[0] >= $U;

      $Vnew = $v0->[1];
      $Unew = $v1->[0];
    }
    $V = $Vnew;

    # The rectangle from (0,0) -> (U,V) is valid.
    my $area = $U * $V;
    $part2 = $area if $area > $part2;

    $U = $Unew;
  }
}

print "Part 2 result: $part2\n";

# Return the direction of the specified edge, given two points.
# 0 -> right  1 -> down  2 -> left  3 -> up
sub dir {
  return 0 if $_[0]->[0] < $_[1]->[0];
  return 1 if $_[0]->[1] < $_[1]->[1];
  return 2 if $_[0]->[0] > $_[1]->[0];
  return 3 if $_[0]->[1] > $_[1]->[1];
  print "$_[0]->[0],$_[0]->[1]  $_[1]->[0],$_[1]->[1]\n";
  die;  # Should never happen with valid input.
}

sub xform {
  my $p = [ 0, 0 ];

  if($xfDir == 0) {
    # No rotation needed
    $p->[0] = $_[0]->[0] - $xfOrigin[0];
    $p->[1] = $_[0]->[1] - $xfOrigin[1];
  } elsif($xfDir == 1) {
    # x = y, y = -x
    $p->[0] = $_[0]->[1] - $xfOrigin[1];
    $p->[1] = -($_[0]->[0] - $xfOrigin[0]);
  } elsif($xfDir == 2) {
    # x = -x, y = -y
    $p->[0] = -($_[0]->[0] - $xfOrigin[0]);
    $p->[1] = -($_[0]->[1] - $xfOrigin[1]);
  } elsif($xfDir == 3) {
    # x = -y, y = x
    $p->[0] = -($_[0]->[1] - $xfOrigin[1]);
    $p->[1] = $_[0]->[0] - $xfOrigin[0];
  } else {
    die;
  }

  return $p;
}

# Return the transformed point at the given index.
sub Point {
  my $id = $_[0];
  $id = $#vertex if $id == -1;
  $id = 0 if $id > $#vertex;
  return xform($vertex[$id]);
}

# Following code is to detect adjacent edges. I used it to process the input
# and make sure that does not occur; since it does not I don't need to
# handle that case seperately.
if(0) {
  # Figure out if any edges are adjacent.
  for my $i (0..$#points-1) {
    my $dir = ($points[$i]->[0] == $points[$i+1]->[0]) ? 0 : 1;

    for my $j ($i+1..$#points-1) {
      my $dir2 = ($points[$j]->[0] == $points[$j+1]->[0]) ? 0 : 1;
      # Don't need to consider perpendicular edges.
      next if $dir2 != $dir;

      # If edge 2 is on a line immediately to one side or the other of edge
      # 1...
      my $d = $points[$i]->[$dir] - $points[$j]->[$dir];
      if($d == 1 || $d == -1) {
        # And the ranges overlap...
        if(overlap($points[$i]->[!$dir], $points[$i+1]->[!$dir],
                   $points[$j]->[!$dir], $points[$j+1]->[!$dir])) {
          # These edges are adjacent.
          print("Adjacent edges detected!\n");
        }
      }
    }
  }
}

sub overlap {
  my ($x1, $x2, $y1, $y2) = @_;
  ($x1,$x2) = ($x2,$x1) if $x1 > $x2;
  ($y1,$y2) = ($y2,$y1) if $y1 > $y2;
  return ($x2 >= $y1 && $x1 <= $y2);
}

# Following code used to determine ordering of vertices; it turns our that
# they are given in clockwise order.
# Determine if the vertices are given in clockwise or counterclockwise order.
if(0) {
  my $polyDir = 0; 
  for my $i (0..$#points) {
    # Use Green's theorum to calculate area of the polygon, solely
    # to determine vertex ordering.
    $polyDir += $points[$i]->[0] * $points[$i+1]->[1] -
                $points[$i]->[1] * $points[$i+1]->[0];
  }
}


