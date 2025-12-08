#!/usr/bin/perl

use strict vars;
use Data::Dumper;

my @points = ( );
my %circuits;

# Read all the data;
while(<>) {
  # Elements: x, y, z, point ID, circuit ID
  push @points, [ $1, $2, $3, $#points+1, $#points+1 ] if /(\d+),(\d+),(\d+)/;
  $circuits{$#points} = [ $#points ];
}

my $maxSteps = 1000;
$maxSteps = 10 if $#points < 100;  # special case for test data

# Create a list of the distance between each pair of points.
my @distTbl;

for my $i (0..$#points - 1) {
  my $p1 = $points[$i];
  for my $j ($i+1..$#points) {
    my $p2 = $points[$j];
    my $dx = $p2->[0] - $p1->[0];
    my $dy = $p2->[1] - $p1->[1];
    my $dz = $p2->[2] - $p1->[2];
    my $d = $dx * $dx + $dy * $dy + $dz * $dz;
    push @distTbl, [ $i, $j, $d ];
  }
}

# Now sort the list in ascending order of distance.
@distTbl = sort { $a->[2] <=> $b->[2] } @distTbl;

# Connect points until they are all in one group
for(my $step = 1; 1; $step++) {
  my $d = shift @distTbl;
  my $c1 = $points[$d->[0]]->[4];
  my $c2 = $points[$d->[1]]->[4];

  if($c2 != $c1) {
    # Combine circuits c1 and c2.
    for my $p (@{$circuits{$c2}}) {
      $points[$p]->[4] = $c1;
      push @{$circuits{$c1}}, $p;
    }
    delete $circuits{$c2};
  }

  if($step == $maxSteps) {
    # Calculate result for part 1.
    # Make a list of all circuits in descending order of size.
    my @sortCircuits = sort { $#$b <=> $#$a } values %circuits;

    my $part1 = 
          scalar(@{$sortCircuits[0]}) *
          scalar(@{$sortCircuits[1]}) *
          scalar(@{$sortCircuits[2]});
    print "Part 1 result: $part1\n";
  }

  # If there's only one circuit left, we're done.
  if(scalar keys %circuits == 1) {
    printf "Part 2 result: %d\n",
      $points[$d->[0]]->[0] * $points[$d->[1]]->[0];
    last;
  }
}
