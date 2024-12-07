#!/usr/bin/perl

use strict vars;

# Read the map
our @board;

my ($sx, $sy);

while(<>) {
  chomp;
  push @board, [ split // ];

  # Check for the starting position.
  if(index($_, "^") != -1) {
    $sx = index($_, "^");
    $sy = $#board;
    $board[$#board]->[$sx] = '.';
  }
}

our $w = scalar @{$board[0]};
our $h = scalar @board;

my $startLoc = $sx + ($sy << 16);

my @visited = findRoute($startLoc);

printf "Part 1 result: %d\n", scalar @visited;

# Try placing an obstacle at each location found and see if it results in
# the route forming a loop.
my $part2;
for my $loc (@visited) {
  next if $loc == $startLoc;

  # Temporarily change this square to '#'.
  my $x = $loc & 0xFFFF;
  my $y = ($loc >> 16);
  $board[$y]->[$x] = '#';

  # Increment part 2 result if findRoute indicates a loop.
  $part2++ if findRoute($startLoc, 1);

  # Change the square back to '.'
  $board[$y]->[$x] = '.';
}

print "Part 2 result: $part2\n";

sub getAt {
  my $loc = $_[0];
  return undef if $loc < 0;
  my $x = $loc & 0xFFFF;
  return undef if $x >= $w;
  my $y = ($loc >> 16);
  return undef if $y >= $h;
  return $board[$y]->[$x];
}

sub validLoc {
  my $loc = $_[0];
  my $x = $loc % 0x10000;
  my $y = int($loc / 0x10000);
  return ($x >= 0 && $y >= 0 && $x < $w && $y < $h);
}

sub findRoute {
  my ($loc, $part2) = @_;
  my @dirs = ( -0x10000, 1, 0x10000, -1 );
  my $dir = 0;

  my %visited = ( );

  do {

    # For part 1, need to track unique squares. For part 2, track
    # square+direction to detect loops.
    if(!$part2) {
      $visited{$loc} = 1;
    } else {
      return 1 if exists $visited{$loc + ($dir << 32)}; # loop found.
      $visited{$loc + ($dir << 32)} = 1;
    }

    if(getAt($loc + $dirs[$dir]) eq '#') {
      # Turn right
      $dir = ($dir + 1) % 4;
    } else {
      # Move forward
      $loc += $dirs[$dir];
    }

  } while(validLoc($loc));

  # Off the edge of the map.
  # For part 1, return the list of locations visited.
  if(!$part2) {
    return keys %visited;
  } else {
    # Part 2, tell the caller that this does not result in a loop.
    return 0;
  }
}
