#!/usr/bin/perl

use strict vars;

# Read all the data
my @map = <>;
chomp @map;

# We want to surround the given map with '.' characters.
# Add strings of '.' at the beginning and end
unshift @map, '.' x length($map[0]);
push @map, '.' x length($map[0]);

# Turn each string into a list of characters, and add '.' at the beginning
# and end.
@map = map { [ '.', (split //), '.' ] } @map;

my @dirs = ( [-1,-1], [-1,0], [-1,1],
             [0,-1], [0,1],
             [1,-1], [1,0], [1,1] );

my $part1 = -1;
my $part2 = 0;
my $count = 0;

do {
  $count = step(\@map);
  $part1 = $count if $part1 == -1;
  $part2 += $count;
} while($count > 0);

print "Part 1 result: $part1\n";
print "Part 1 result: $part2\n";

sub step {
  my $map = $_[0];

  # Make a copy of the map.
  my @newMap = map { [ @$_ ] } @$map;

  my $total;

  # Iterate through all cells in the map
  for my $y (1..$#$map-1) {
    for my $x (1..$#{$map->[0]}-1) {

      # Only consider '@' cells
      next if $map->[$y]->[$x] ne '@';

      # Count adjacent '@' cells
      my $count = 0;
      for my $dir (@dirs) {
        $count++ if $map->[$y + $dir->[0]]->[$x + $dir->[1]] eq '@';
      }

      # If there are less than 3 adjacent '@' characters, then increment the
      # total and remove this '@' from the new map.
      if($count < 4) {
        $total++;
        $newMap[$y]->[$x] = '.';
      }
    }
  }

  # Copy the new data back to the original map structure.
  for my $i (0..$#$map) { $map->[$i] = $newMap[$i]; }

  return $total;
}
