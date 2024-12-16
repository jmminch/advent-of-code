#!/usr/bin/perl

use strict vars;

our @map = <>;
chomp @map;
@map = map { [ split // ] } @map;

our @dirs = ( -65536, 1, 65536, -1 );

# Figure out the locations of all connecting portals.
my %portals = ( );
for my $y (1..$#map - 1) {
  for my $x (1..$#{$map[$y]} - 1) {
    if(isLetter($map[$y]->[$x])) {

      if(isLetter($map[$y-1]->[$x]) && $map[$y+1]->[$x] eq '.') {
        $map[$y]->[$x] = $map[$y-1]->[$x] . $map[$y]->[$x];
        push @{$portals{$map[$y]->[$x]}}, ($y + 1) * 65536 + $x;
      }

      if(isLetter($map[$y+1]->[$x]) && $map[$y-1]->[$x] eq '.') {
        $map[$y]->[$x] = $map[$y]->[$x] . $map[$y+1]->[$x];
        push @{$portals{$map[$y]->[$x]}}, ($y - 1) * 65536 + $x;
      }

      if(isLetter($map[$y]->[$x-1]) && $map[$y]->[$x+1] eq '.') {
        $map[$y]->[$x] = $map[$y]->[$x-1] . $map[$y]->[$x];
        push @{$portals{$map[$y]->[$x]}}, $y * 65536 + $x + 1;
      }

      if(isLetter($map[$y]->[$x+1]) && $map[$y]->[$x-1] eq '.') {
        $map[$y]->[$x] = $map[$y]->[$x] . $map[$y]->[$x+1];
        push @{$portals{$map[$y]->[$x]}}, $y * 65536 + $x - 1;
      }
    }
  }
}

# Part 1 - labeled exits lead to the other exit with the same label.
my @q = ( [ 0, $portals{'AA'}->[0] ] );
my %visited = ( );
while(my $pt = shift @q) {
  next if exists $visited{$pt->[1]};
  $visited{$pt->[1]} = 1;
  if($pt->[1] == $portals{'ZZ'}->[0]) {
    print "Part 1 result: $pt->[0]\n";
    last;
  }

  for my $d (@dirs) {
    my $c = get($pt->[1] + $d);
    if($c eq '.') {
      push @q, [ $pt->[0] + 1, $pt->[1] + $d ];
    } elsif(isLetter($c)) {
      for my $loc (@{$portals{$c}}) {
        push @q, [ $pt->[0] + 1, $loc ];
      }
    }
  }
}

# Part 2 - Interior labeled exits lead to the exterior of a higher-level
# maze. The third entry in the state is the maze level.
@q = ( [ 0, $portals{'AA'}->[0], 0 ] );
%visited = ( );
while(my $pt = shift @q) {
  my $cacheKey = $pt->[1] + (1 << 32) * $pt->[2];
  next if exists $visited{$cacheKey};
  $visited{$cacheKey} = 1;
  if($pt->[1] == $portals{'ZZ'}->[0] && $pt->[2] == 0) {
    print "Part 2 result: $pt->[0]\n";
    last;
  }

  for my $d (@dirs) {
    my $c = get($pt->[1] + $d);
    if($c eq '.') {
      push @q, [ $pt->[0] + 1, $pt->[1] + $d, $pt->[2] ];
    } elsif(isLetter($c)) {
      next if $c eq 'AA' || $c eq 'ZZ';

      # Determine if this is on the outside or inside edge.
      my $x = $pt->[1] % 65536;
      my $y = int($pt->[1] / 65536);
      my $outside = ($y == 2 || $x == 2 ||
                     $y == $#map - 2 || $x == $#{$map[$y]} - 2);

      next if $outside && $pt->[2] == 0;

      for my $loc (@{$portals{$c}}) {
        next if $loc == $pt->[1];
        push @q, [ $pt->[0] + 1, $loc, $pt->[2] + ($outside ? -1 : 1) ];
      }
    }
  }
}



sub isLetter {
  return ord($_[0]) >= 65 && ord($_[0] <= 90);
}

sub get {
  my $x = $_[0] % 65536;
  my $y = int($_[0] / 65536);
  return '#' if $x < 0 || $y < 0 || $y > $#map || $x > $#{$map[$y]};
  return $map[$y]->[$x];
}
