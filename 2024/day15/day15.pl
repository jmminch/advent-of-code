#!/usr/bin/perl

use strict vars;
use Data::Dumper;

my @map;
my $moves;
while(<>) {
  chomp;
  if(/^#/) {
    push @map, [ split // ];
    next;
  }

  $moves .= $_ if /[<>v^]/;
}

#our @dirs = ( -65536, 1, 65536, -1 );
our %dirs = ( '^' => -65536, 'v' => 65536, '>' => 1, '<' => -1 );

sub get {
  my $x = $_[0] % 65536;
  my $y = int($_[0] / 65536);
  return '#' if $x < 0 || $y < 0 || $y > $#map || $x > $#{$map[$y]};
  return $map[$y]->[$x];
}

sub set {
  my $x = $_[0] % 65536;
  my $y = int($_[0] / 65536);
  return if $x < 0 || $y < 0 || $y > $#map || $x > $#{$map[$y]};
  $map[$y]->[$x] = $_[1];
}


# Find the starting location
my $loc;
for my $y (0..$#map) {
  for my $x (0..$#{$map[$y]}) {
    my $c = $map[$y]->[$x];
    $loc = $y * 65536 + $x if $map[$y]->[$x] eq '@';
  }
}

for my $move (split //, $moves) {
  my $dir = $dirs{$move};
  $loc += $dir if try_push($loc, $dir);
}

my $part1 = 0;
for my $y (0..$#map) {
  for my $x (0..$#{$map[$y]}) {
    my $c = $map[$y]->[$x];
    $part1 += 100 * $y + $x if $map[$y]->[$x] eq 'O';
  }
}

print "Part 1 result: $part1\n";


sub try_push {
  my $l = $_[0];
  my $d = $_[1];

  my $c = get($l + $d);
  return 0 if $c eq '#';  # hit a wall
  try_push($l + $d, $d) if $c eq 'O';
  $c = get($l + $d);
  if($c eq '.') {
    set($l + $d, get($l));
    set($l, '.');
    return 1;
  }

  return 0;
}
