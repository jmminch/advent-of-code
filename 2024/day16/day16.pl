#!/usr/bin/perl

use strict vars;
use Heap::Binary;

our @map = <>;
chomp @map;
@map = map { [ split // ] } @map;

our $h = scalar @map;

my @dirs = (1, 65536, -1, -65536);

# Find the starting and ending positions
my ($startLoc, $endLoc);
for my $y (0..$#map) {
  for my $x (0..$#{$map[$y]}) {
    $startLoc = $y * 65536 + $x if $map[$y]->[$x] eq 'S';
    $endLoc = $y * 65536 + $x if $map[$y]->[$x] eq 'E';
  }
}

my $heap = Heap::Binary->new();
$heap->add(Pt->new(0, $startLoc, 0, -1));
my %distMap;

my $part1 = 99999999;

while(defined(my $x = $heap->extract_top)) {
  my $pt = $x->val;

  last if $pt->[0] > $part1;

  my $c = get($pt->[1]);

  next if $c eq '#';

  $part1 = $pt->[0] if $c eq 'E';

  my $cacheKey = $pt->[1] + $pt->[2] * (1 << 32);
  if(exists $distMap{$cacheKey}) {
    next if $distMap{$cacheKey}->[0] < $pt->[0];
    push @{$distMap{$cacheKey}}, $pt->[3]; # nodes that point to this one.
    next;
  } else {
    $distMap{$cacheKey} = [$pt->[0], $pt->[3]];
  }

  my $dir = $dirs[$pt->[2]];
  $heap->add(Pt->new($pt->[0] + 1, $pt->[1] + $dir, $pt->[2], $cacheKey));
  $heap->add(Pt->new($pt->[0] + 1000, $pt->[1], ($pt->[2] + 1) % 4, $cacheKey));
  $heap->add(Pt->new($pt->[0] + 1000, $pt->[1], ($pt->[2] + 3) % 4, $cacheKey));
}

print "Part 1 result: $part1\n";

# Now work backwards to determine all points that are on one of the paths
# with length $part1.
my %part2;
for my $endDir (0..3) {
  my $cacheKey = $endLoc + $endDir * (1 << 32);
  next if !exists $distMap{$cacheKey};
  my @q = ( $cacheKey );
  while (my $key = shift @q) {
    next if $key == -1;
    my $loc = $key & 0xffffffff;
    $part2{$loc} = 1;
    for my $i (1..$#{$distMap{$key}}) {
      push @q, $distMap{$key}->[$i];
    }
  }
}

printf "Part 2 result: %d\n", scalar keys %part2;

sub get {
  my $x = $_[0] % 65536;
  my $y = int($_[0] / 65536);
  return '#' if $x < 0 || $y < 0 || $y > $#map || $x > $#{$map[$y]};
  return $map[$y]->[$x];
}

package Pt;

use parent(Heap::Elem);

# Parameters: dist, location, facing direction, parent
sub new {
  my $class = shift;
  my $self = Heap::Elem->new([ @_ ]);
  bless $self, $class;
  return $self;
}

sub cmp {
  my $self = shift;
  my $other = shift;
  return $self->val->[0] <=> $other->val->[0];
}
