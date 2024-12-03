#!/usr/bin/perl

use Digest::MD5 qw(md5);
use strict 'vars';

our %cache;

# nodes{node id} = [ size, used, avail ]
my %nodes;

# read input data

my $goalX = -1;
my ($maxX, $maxY);

while(<>) {
  if(/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T/) {
    my $x = $1;
    my $y = $2;

    $maxX = $x if $x > $maxX;
    $maxY = $y if $y > $maxY;
    $goalX = $x if $x > $goalX && $y == 0;

    my $loc = ($y << 16) + $x;
    $nodes{$loc} = [ $3, $4, $5 ];
  }
}

# For part 1, count all pairs of nodes (A,B) where:
#   A != B
#   A used > 0
#   A used <= B avail
my $part1 = 0;
for my $A (keys %nodes) {
  for my $B (keys %nodes) {
    next if $A eq $B;
    next if $nodes{$A}->[1] == 0;
    next if $nodes{$A}->[1] > $nodes{$B}->[2];
    $part1++;
  }
}

# Now convert to a flat array for processing.
my %map = (
  w => $maxX + 1,
  h => $maxY + 1,
  goalX => $goalX,
  goalY => 0,
  moves => 0,
  cells => [ ]
);

for my $loc (keys %nodes) {
  my $x = $loc & 0xffff;
  my $y = $loc >> 16;
  my $data = $nodes{$loc};
  $map{cells}->[$x + $y * $map{w}] = ($data->[0] << 16) | $data->[1];
}

addCache(\%map);

# For part 2, we're going to do a breadth-first search of all the movement
# possibilities until finding a solution that moves the data from y=0 and
# max x back to y=0, x=0.
my @queue = ( \%map );
my $part2 = 0;
while( my $map = shift @queue )
{
  if($map->{goalX} == 0 && $map->{goalY} == 0) {
    $part2 = $map->{moves};
    last;
  }

  push @queue, findAllMoves($map);

  printf "queue len: %d, depth: %d\n", scalar @queue, $queue[0]->{moves};
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub addCache {
  $cache{mapHash($_[0])} = 1;
}

sub checkCache {
  return exists($cache{mapHash($_[0])});
}

sub mapHash {
  my $map = $_[0];
  if(!exists($map->{hash})) {
    my $data = pack("SSL*", $map->{goalX}, $map->{goalY},
                            @{$map->{cells}});
    my $hash = md5($data);
    $map->{hash} = $hash;
  }

  return $map->{hash};
}

sub cellId {
  return $_[0]->{w} * $_[2] + $_[1];
}

sub copyMap {
  my $map = $_[0];
  my $newMap = { };
  $newMap->{w} = $map->{w};
  $newMap->{h} = $map->{h};
  $newMap->{goalX} = $map->{goalX};
  $newMap->{goalY} = $map->{goalY};
  $newMap->{moves} = $map->{moves};
  $newMap->{cells} = [ @{$map->{cells}} ];
  return $newMap;
}

sub findAllMoves {
  my $map = $_[0];
  my @dirs = ( [-1,0], [1,0], [0,-1], [0,1] );
  my @r = ( );
  for my $y (0..$map->{h} - 1) {
    for my $x (0..$map->{w} - 1) {
      my $c1 = cellId($map, $x, $y);
      for my $dir (@dirs) {
        my $x2 = $x + $dir->[0];
        my $y2 = $y + $dir->[1];
        next if $x2 < 0 || $y2 < 0 || $x2 >= $map->{w} || $y2 >= $map->{h};
        my $c2 = cellId($map, $x2, $y2);

        # Determine if the data from cell 1 can be moved to cell 2
        my $avail2 = $map->{cells}->[$c2];
        $avail2 = (($avail2 >> 16) - ($avail2 & 0xffff));
        my $used1 = $map->{cells}->[$c1] & 0xffff;
        if($used1 > 0 && $used1 <= $avail2) {
          
          # It can be. Create a new map with this data.
          my $newMap = copyMap($map);

          # clear low 16 bits of cell 1
          $newMap->{cells}->[$c1] &= 0xffff0000;
          # Add in amount of used data to cell 2
          $newMap->{cells}->[$c2] += $used1;

          $newMap->{moves}++;
          if($x == $map->{goalX} && $y == $map->{goalY}) {
            $newMap->{goalX} = $x2;
            $newMap->{goalY} = $y2;
          }

          # Check if this state has already been seen.
          next if checkCache($newMap);
          addCache($newMap);

          push @r, $newMap;
        }
      }
    }
  }

  return @r;
}