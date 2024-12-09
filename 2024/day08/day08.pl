#!/usr/bin/perl

use strict vars;

my %antenna;
my $h = 0;
my $w = 0;
while(<>) {
  chomp;
  my @c = split //;
  $w = scalar @c;
  for my $x (0..$#c) {
    if($c[$x] ne '.') {
      push @{$antenna{$c[$x]}}, [ $x, $h ];
    }
  }
  $h++;
}

my %antinodes;
for my $aType (keys %antenna) {
  my $locs = $antenna{$aType};

  for my $i (0..$#$locs) {
    for my $j (0..$#$locs) {
      next if $i == $j;
      my $dx = $locs->[$j]->[0] - $locs->[$i]->[0];
      my $dy = $locs->[$j]->[1] - $locs->[$i]->[1];
      my $x = $locs->[$i]->[0] - $dx;
      my $y = $locs->[$i]->[1] - $dy;
      next if $x < 0 || $y < 0 || $x >= $w || $y >= $h;
      $antinodes{"$x.$y"}++;
    }
  }
}

printf "Part 1 result: %d\n", scalar keys %antinodes;

my %antinodes = ( );

for my $aType (keys %antenna) {
  my $locs = $antenna{$aType};

  for my $i (0..$#$locs) {
    for my $j (0..$#$locs) {
      next if $i == $j;
      my $dx = $locs->[$j]->[0] - $locs->[$i]->[0];
      my $dy = $locs->[$j]->[1] - $locs->[$i]->[1];

      # Go forward until outside the bounds of the map.
      # Backwards will be handled when we look at the other node.
      my $x = $locs->[$i]->[0];
      my $y = $locs->[$i]->[1];
      while($x >= 0 && $y >= 0 && $x < $w && $y < $h) {
        $antinodes{"$x.$y"}++;
        $x += $dx;
        $y += $dy;
      }
    }
  }
}

printf "Part 2 result: %d\n", scalar keys %antinodes;
