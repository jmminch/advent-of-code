#!/usr/bin/perl

use strict vars;

our $w = 71;
our $h = 71;
our @map;

my @coord = <>;
chomp @coord;

our @map;
for my $c (@coord[0..1023]) {
  my ($x, $y) = split /,/, $c;
  $map[$y]->[$x] = '#';
}

printf "Part 1 result: %d\n", findPath();

my $x0 = 1024;
my $x1 = $#coord;
while(1) {
  my $t = int(($x0 + $x1) / 2);
  @map = ( );
  for my $c (@coord[0..$t]) {
    my ($x, $y) = split /,/, $c;
    $map[$y]->[$x] = '#';
  }
  my $r = findPath();
  if($r != -1) {
    $x0 = $t + 1;
  } else {
    $x1 = $t;
  }

  if($x0 == $x1) {
    my ($x, $y) = split /,/, $coord[$x0];
    print "Part 2 result: $x,$y\n";
    last;
  }
}

sub get {
  my $x = $_[0] % 65536;
  my $y = int($_[0] / 65536);
  return '#' if $x < 0 || $y < 0 || $y >= $h || $x >= $w;
  return $map[$y]->[$x];
}

sub findPath {
  my @dirs = (1, 65536, -1, -65536);
  my @q = ( [0, 0] );
  my %visited = ( );
  while(my $pt = shift @q) {
    my $loc = $pt->[0];

    my $x = $loc % 65536;
    my $y = int($loc / 65536);
    if($x == $w - 1 && $y == $h - 1) {
      return $pt->[1];
    }

    next if exists $visited{$loc};
    $visited{$loc} = 1;

    next if get($loc) eq '#';

    for my $d (@dirs) {
      push @q, [ $loc + $d, $pt->[1] + 1 ];
    }
  }

  return -1;
}
