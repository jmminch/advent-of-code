#!/usr/bin/perl

use strict vars;
use Data::Dumper;

# Read in the map. @map1 is for part1, @map2 is the expanded map for part2.
my @map1;
my @map2;
my $moves;
while(<>) {
  chomp;
  if(/^#/) {
    push @map1, [ split // ];
    my @c = split //;
    my %mapping = ( '#' => '##', 'O' => '[]', '.' => '..', '@' => '@.' );
    for my $i (0..$#c) {
      $c[$i] = $mapping{$c[$i]};
    }
    my $x = join '', @c;
    push @map2, [ split //, $x ];
    next;
  }

  $moves .= $_ if /[<>v^]/;
}

our %dirs = ( '^' => -65536, 'v' => 65536, '>' => 1, '<' => -1 );

# Find the starting location
my $startLoc;
my $startLoc2;
for my $y (0..$#map1) {
  for my $x (0..$#{$map1[$y]}) {
    if($map1[$y]->[$x] eq '@') {
      $startLoc = $y * 65536 + $x;
      $startLoc2 = $y * 65536 + $x * 2;
    }
  }
}

# Part 1
our $map = \@map1;
my $loc = $startLoc;
for my $move (split //, $moves) {
  my $dir = $dirs{$move};
  $loc += $dir if try_push($loc, $dir);
}

my $part1 = 0;
for my $y (0..$#$map) {
  for my $x (0..$#{$map->[$y]}) {
    my $c = $map->[$y]->[$x];
    $part1 += 100 * $y + $x if $map->[$y]->[$x] eq 'O';
  }
}

print "Part 1 result: $part1\n";

# Part 2
$map = \@map2;
$loc = $startLoc2;
for my $move (split //, $moves) {
  my $dir = $dirs{$move};
  $loc += $dir if try_push($loc, $dir);
}

my $part2 = 0;
for my $y (0..$#$map) {
  for my $x (0..$#{$map->[$y]}) {
    my $c = $map->[$y]->[$x];
    $part2 += 100 * $y + $x if $map->[$y]->[$x] eq '[';
  }
}

print "Part 2 result: $part2\n";

sub printBoard {
  for my $y (0..$#$map) {
    print (join '', @{$map->[$y]});
    print "\n";
  }
}

sub get {
  my $x = $_[0] % 65536;
  my $y = int($_[0] / 65536);
  return '#' if $x < 0 || $y < 0 || $y > $#$map || $x > $#{$map->[$y]};
  return $map->[$y]->[$x];
}

sub set {
  my $x = $_[0] % 65536;
  my $y = int($_[0] / 65536);
  return if $x < 0 || $y < 0 || $y > $#$map || $x > $#{$map->[$y]};
  $map->[$y]->[$x] = $_[1];
}

sub check_push {
  my $l = $_[0];
  my $d = $_[1];
  my @pushSq = ($l);

  my $c = get($l);
  if($c eq '[' && abs($d) > 10) {
    push @pushSq, $l + 1;
  } elsif($c eq ']' && abs($d) > 10) {
    push @pushSq, $l - 1;
  }

  for my $sq (@pushSq) {
    my $next = $sq + $d;
    my $c2 = get($next);
    return 0 if $c2 eq '#';
    if($c2 eq '[' || $c2 eq ']' || $c2 eq 'O') {
      return 0 if !check_push($next, $d);
    }
  }

  return 1;
}

sub try_push {
  my $l = $_[0];
  my $d = $_[1];

  return 0 if !check_push($l, $d);

  my @pushSq = ($l);

  my $c = get($l);
  if($c eq '[' && abs($d) > 10) {
    push @pushSq, $l + 1;
  } elsif($c eq ']' && abs($d) > 10) {
    push @pushSq, $l - 1;
  }

  for my $sq (@pushSq) {
    my $next = $sq + $d;
    my $c2 = get($next);
    return 0 if $c2 eq '#';
    if($c2 eq '[' || $c2 eq ']' || $c2 eq 'O') {
      try_push($next, $d);
    }

    set($next, get($sq));
    set($sq, '.');
  }

  return 1;
}
