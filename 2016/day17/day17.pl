#!/usr/bin/perl

use Digest::MD5 qw(md5_hex);
use strict 'vars';

my $passcode = shift // 'pgflpeqp';

# Each state has the following:
# x position
# y position
# maze state string
# distance from start

my @states = ( [ 0, 0, $passcode, 0 ] );

my @dirs = ( [ 0, -1, 'U' ], [ 0, 1, 'D' ], [ -1, 0, 'L' ], [ 1, 0, 'R' ] );

my ($part1, $part2);

while(my $state = shift @states) {

  if($state->[0] == 3 && $state->[1] == 3) {
    # solution found.
    if(!defined($part1)) {
      # Part 1 is the path part of the maze state string for the first
      # solution found.
      $part1 = substr($state->[2], length $passcode);
    }

    # Part 2 is the longest path found; since this is a BFS it's the last
    # path to find.
    $part2 = $state->[3];
    next;
  }
  
  # Generate the hash for this state
  my $md5 = md5_hex($state->[2]);

  # Loop through all four directions
  for(my $i = 0; $i < 4; $i++) {
    if(ord(substr($md5, $i, 1)) > ord('a')) { # door open
      my $dir = $dirs[$i];
      my $nx = $state->[0] + $dir->[0];
      my $ny = $state->[1] + $dir->[1];
      next if $nx < 0 || $nx > 3 || $ny < 0 || $ny > 3;
      push @states, [ $nx, $ny, $state->[2] . $dir->[2], $state->[3] + 1 ];
    }
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
