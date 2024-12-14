#!/usr/bin/perl

use strict vars;

# Read the map
our @map = <>;
chomp @map;
@map = map { [ split // ] } @map;
our $h = scalar @map;
our $w = scalar @{$map[0]};

# Dirs in clockwise order
our @dirs = ( -65536, 1, 65536, -1 );

our %regionMap;

my $part1 = 0;
my $part2 = 0;

# findRegion will return regions until all are found.
while(my $region = findRegion()) {
  my $perimeter = 0;
  my $sides = 0;
  for my $loc (keys %{$region}) {
    for my $dirId (0..$#dirs) {
      my $dir = $dirs[$dirId];
      if(not exists $region->{$loc + $dir}) {
        # The cell across this boundary is not within the region, so this
        # boundary is part of the perimeter.
        $perimeter++;

        # To count the number of sides in the region, only count this cell
        # if it is at one end of a row. So if there is another cell in this
        # row, and that cell also has a boundary in the same direction, then
        # don't count it.
        my $dir2 = $dirs[($dirId + 1) % 4];
        my $loc2 = $loc + $dir2;
        if(!exists $region->{$loc2} ||
           exists $region->{$loc2 + $dir}) {
          $sides++;
        }
      }
    }
  }
  my $price = $perimeter * scalar keys %{$region};
  $part1 += $price;
  my $price2 = $sides * scalar keys %{$region};
  $part2 += $price2;
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub getAt {
  my $loc = $_[0];
  my $y = $_[0] / 65536;
  my $x = $_[0] % 65536;
  return '.' if $y < 0 || $x < 0 || $y >= $h || $x >= $w;
  return $map[$y]->[$x];
}

sub findRegion {
  # Find a square with a letter that is not already part of an identified
  # region.
  my $loc = 0;
  LOOP: for(my $y = 0; $y <= $#map; $y++, $loc = ($loc + 65536) & 0xFFFF0000) {
    for(my $x = 0; $x <= $#{$map[0]}; $x++, $loc++) {
      next if exists $regionMap{$loc};
      next if getAt($loc) eq '.';
      last LOOP;
    }
  }

  # No more regions
  return undef if getAt($loc) eq '.';

  # Find all squares in this region using BFS
  my %region = ();
  my @q = ( $loc );
  my $char = getAt($loc);
  while(defined(my $loc = shift @q)) {
    next if exists $region{$loc};
    next if getAt($loc) ne $char;
    $region{$loc} = $char;
    $regionMap{$loc} = $char;
    for my $dir (@dirs) {
      push @q, $loc + $dir;
    }
  }

  return \%region;
}
