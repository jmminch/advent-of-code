#!/usr/bin/perl

use Digest::MD5 qw(md5);
use strict 'vars';

our %cache;

# nodes{node id} = [ size, used, avail ]
my %nodes;

# read input data

my $goalX = -1;
my $eX = 0;
my $eY = 0;
my ($maxX, $maxY);

while(<>) {
  if(/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T/) {
    my $x = $1;
    my $y = $2;

    $maxX = $x if $x > $maxX;
    $maxY = $y if $y > $maxY;
    $goalX = $x if $x > $goalX && $y == 0;
    $eX = $x if $4 == 0;
    $eY = $y if $4 == 0;

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
  eX => $eX,
  eY => $eY,
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
    my $hash = "$map->{goalX}.$map->{goalY}.$map->{eX}.$map->{eY}";
    #my $data = pack("SSL*", $map->{goalX}, $map->{goalY},
    #                        @{$map->{cells}});
    #my $hash = md5($data);
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
  my $x = $map->{eX};
  my $y = $map->{eY};
  my $c1 = cellId($map, $x, $y);

  for my $dir (@dirs) {
    my $x2 = $x + $dir->[0];
    my $y2 = $y + $dir->[1];
    next if $x2 < 0 || $y2 < 0 || $x2 >= $map->{w} || $y2 >= $map->{h};
    my $c2 = cellId($map, $x2, $y2);

    # Determine if the data from cell 2 can be moved to cell 1
    my $avail1 = $map->{cells}->[$c1];
    $avail1 = (($avail1 >> 16) - ($avail1 & 0xffff));
    my $used2 = $map->{cells}->[$c2] & 0xffff;
    if($used2 > 0 && $used2 <= $avail1) {
      
      # It can be. Create a new map with this data.
      my $newMap = copyMap($map);

      # clear low 16 bits of cell 2
      $newMap->{cells}->[$c2] &= 0xffff0000;
      # Add in amount of used data to cell 2
      $newMap->{cells}->[$c1] += $used2;

      $newMap->{moves}++;
      if($x2 == $map->{goalX} && $y2 == $map->{goalY}) {
        $newMap->{goalX} = $x;
        $newMap->{goalY} = $y;
      }
      $newMap->{eX} = $x2;
      $newMap->{eY} = $y2;

      # Check if this state has already been seen.
      next if checkCache($newMap);
      addCache($newMap);

      push @r, $newMap;
    }
  }

  return @r;
}
