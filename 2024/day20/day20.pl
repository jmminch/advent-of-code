#!/usr/bin/perl

use strict vars;

our @map = <>;
chomp @map;
@map = map { [ split // ] } @map;

our $h = scalar @map;
our $w = scalar @{$map[0]};

our @dirs = (1, 65536, -1, -65536);

# Find the starting and ending positions
my ($startLoc, $endLoc);
for my $y (0..$#map) {
  for my $x (0..$#{$map[$y]}) {
    $startLoc = $y * 65536 + $x if $map[$y]->[$x] eq 'S';
    $endLoc = $y * 65536 + $x if $map[$y]->[$x] eq 'E';
  }
}

# Build a table of how far each square is from the start.
my @q = ( [ $startLoc, 0 ] );
my %distTbl = ( );
while(my $pt = shift @q ) {
  next if get($pt->[0]) eq '#';
  next if exists $distTbl{$pt->[0]};
  $distTbl{$pt->[0]} = $pt->[1];

  for my $d (@dirs) {
    push @q, [ $pt->[0] + $d, $pt->[1] + 1 ];
  }
}

# For each square that was found:
# Jump 2 squares in each direction
# skip if no valid square at that location
# Otherwise, time saved is time[1] - time[0] - 2

my $part1 = 0;
for my $sq (keys %distTbl) {
  for my $d (@dirs) {
    next if get($sq + 2 * $d) eq '#';
    my $ts = $distTbl{$sq + 2 * $d} - $distTbl{$sq} - 2;
    $part1++ if $ts >= 100;
  }
}

print "Part 1 result: $part1\n";


# Part 2: may move up to 20 picoseconds, so to any square with a manhattan
# distance of 20 or less.

my $part2 = 0;
for my $sq (keys %distTbl) {
  my $x = $sq % 65536;
  my $y = int($sq / 65536);

  for my $dy (-20..20) {
    my $maxx = 20 - abs($dy);
    for my $dx (-$maxx..$maxx) {
      my $x2 = $x + $dx;
      my $y2 = $y + $dy;
      next if $x2 < 0 || $y2 < 0 || $y2 >= $h || $x2 >= $w;
      my $sq2 = $y2 * 65536 + $x2;
      next if get($sq2) eq '#';
      my $ts = $distTbl{$sq2} - $distTbl{$sq} - abs($dx) - abs($dy);
      $part2++ if $ts >= 100;
    }
  }
}

print "Part 2 result: $part2\n";



sub get {
  my $x = $_[0] % 65536;
  my $y = int($_[0] / 65536);
  return '#' if $x < 0 || $y < 0 || $y > $#map || $x > $#{$map[$y]};
  return $map[$y]->[$x];
}

