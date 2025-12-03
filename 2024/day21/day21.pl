#!/usr/bin/perl

use strict vars;
use Storable qw(dclone);

my @digPad =
  ( [ 7, 8, 9 ], [ 4, 5, 6 ] , [ 1, 2, 3 ], [ 'X', 0, 'A' ] );

my @dirPad = 
  ( [ 'X', '^', 'A' ], [ '<', 'v', '>' ] );

# Create lookup tables for the location of each button on the keypads.
my %digLoc = ( );
for my $y (0..$#digPad) {
  for my $x (0..$#{$digPad[$y]}) {
    $digLoc{$digPad[$y]->[$x]} = [ $x, $y ];
  }
}

my %dirLoc = ( );
for my $y (0..$#dirPad) {
  for my $x (0..$#{$dirPad[$y]}) {
    $dirLoc{$dirPad[$y]->[$x]} = [ $x, $y ];
  }
}

# The @keypads arrays are arrays that define each of the robot-controlled
# keypads. For part 1, there is one digit pad and two directional pads; for
# part 2 it is one digit pad and 25 directional pads.
my @keypads = (
  [ \@digPad, \%digLoc, [ 2, 3 ] ],
  [ \@dirPad, \%dirLoc, [ 2, 0 ] ],
  [ \@dirPad, \%dirLoc, [ 2, 0 ] ] );

my @keypads2 = ( [ \@digPad, \%digLoc, [ 2, 3 ] ] );
for my $i (1..25) {
  push @keypads2, [ \@dirPad, \%dirLoc, [ 2, 0 ] ];
}

my $part1;
my $part2;

while(<>) {
  chomp;
  next if !/[A0-9]/;

  my $pathLen = shortestPath(\@keypads, 0, $_);

  $part1 += int($_) * $pathLen;

  $pathLen = shortestPath(\@keypads2, 0, $_);

  $part2 += int($_) * $pathLen;
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

our %cache = ( );

sub shortestPath {
  my ($keypads, $depth, $str) = @_;

  return length($str) if $depth > $#{$keypads};

  my $cacheKey = "$#{$keypads}-$depth-$str";
  return $cache{$cacheKey} if exists $cache{$cacheKey};

  my $kp = $keypads->[$depth];

  my @loc = @{$kp->[2]};
  my $r;

  for my $c (split //, $str) {
    my $nextLoc = $kp->[1]->{$c};
    my @moves = getMoves($kp, \@loc, $nextLoc);

    my $minLen = 99999999999999;
    
    for my $m (@moves) {
      my $pathLen = shortestPath($keypads, $depth + 1, $m);
      $minLen = $pathLen if $pathLen < $minLen;
    }
    
    $r += $minLen;

    @loc = @{$nextLoc};
  }

  $cache{$cacheKey} = $r;

  return $r;
}

# Determine the possible move string to push a button at a particular
# location.
# There may be two possibilities (one moving vertically first, and one
# moving horizontally first.)
sub getMoves {
  my ($kp, $loc0, $loc1) = @_;
  my $dx = $loc1->[0] - $loc0->[0];
  my $dy = $loc1->[1] - $loc0->[1];

  my @r;

  if($dy && ($kp->[0]->[$loc0->[1] + $dy]->[$loc0->[0]] ne 'X')) {
    # Moving vertical first is allowed.
    my $path = "";
    if($dy < 0) {
      $path .= '^' x abs($dy);
    } else {
      $path .= 'v' x $dy;
    }

    if($dx < 0) {
      $path .= '<' x abs($dx);
    } else {
      $path .= '>' x $dx;
    }

    $path .= 'A';
    push @r, $path;
  }

  if($dx && ($kp->[0]->[$loc0->[1]]->[$loc0->[0] + $dx] ne 'X')) {
    # Moving horizontally first is allowed.
    my $path = "";
    if($dx < 0) {
      $path .= '<' x abs($dx);
    } else {
      $path .= '>' x $dx;
    }

    if($dy < 0) {
      $path .= '^' x abs($dy);
    } else {
      $path .= 'v' x $dy;
    }

    $path .= 'A';
    push @r, $path;
  }

  if(!$dx && !$dy) {
    push @r, 'A';
  }

  return @r;
}
