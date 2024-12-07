#!/usr/bin/perl

use strict vars;

# Read the board
our @board;
while(<>) {
  chomp;
  push @board, [ split // ];
}

our $w = scalar @{$board[0]};
our $h = scalar @board;

my $part1 = 0;
my $part2 = 0;

# Loop through every starting point.
for my $y (0..$h-1) {
  for my $x (0..$w-1) {
    my $loc = $y * 0x10000 + $x;

    # Find the 4-letter word in each possible direction (0-7)
    for my $dir (0..7) {
      $part1++ if getStringAt($loc, $dir) eq 'XMAS';
    }

    # Determine if there is an "X-MAS" pattern centered at this location.
    $part2++ if xmasAt($loc);
  }
}

print "Part 1 result: $part1\n";
print "Part 1 result: $part2\n";

# coordinates are encoded as ( y * 0x10000 + x )
sub getCharAt {
  my $loc = $_[0];
  return undef if $loc < 0;
  my $x = $loc & 0xFFFF;
  return undef if $x >= $w;
  my $y = ($loc >> 16);
  return undef if $y >= $h;
  return $board[$y]->[$x];
}

sub getStringAt {
  my ($loc, $dir) = @_;
  my @dirs = ( -0x10001, -0x10000, -0xffff, -1, 1, 0xffff, 0x10000, 0x10001 );
  my $s = "";
  for my $i (1..4) {
    my $c = getCharAt($loc);
    return undef if !defined $c;
    $s .= $c;
    $loc += $dirs[$dir];
  }
  return $s;
}

sub xmasAt {
  my $loc = $_[0];
  return 0 if getCharAt($loc) ne 'A';

  # Find the characters for the diagonally adjacent squares.
  my $ul = getCharAt($loc - 0x10001);
  my $ur = getCharAt($loc - 0xffff);
  my $dl = getCharAt($loc + 0xffff);
  my $dr = getCharAt($loc + 0x10001);

  # Check whether both diagonals form 'MAS' in some direction.
  if( (($ul eq 'M' && $dr eq 'S') || ($ul eq 'S' && $dr eq 'M')) &&
      (($ur eq 'M' && $dl eq 'S') || ($ur eq 'S' && $dl eq 'M')) ) {
    return 1;
  }

  return 0;
}
