#!/usr/bin/perl

use strict vars;

# Read the input map
our @map = <>;
chomp @map;
@map = map { [ split // ] } @map;
our $h = scalar @map;
our $w = scalar @{$map[0]};

# Sum reachablePeaks for every 0 square.
my $part1 = 0;
my $part2 = 0;
for my $y (0..$h - 1) {
  for my $x (0..$w - 1) {
    my $loc = (($y + 256) << 16) | ($x + 256);
    if(getAt($loc) == 0) {
      my @peaks = reachablePeaks2($loc);
      $part2 += scalar @peaks;
      my %uniquePeaks = ();
      for my $peak (@peaks) { $uniquePeaks{$peak} = 1; }
      $part1 += scalar keys %uniquePeaks;
    }
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub getAt {
  my $loc = $_[0];
  my $x = ($loc & 0xFFFF) - 256;
  my $y = ($loc >> 16) - 256;
  return -1 if $x < 0 || $x >= $w || $y < 0 || $y >= $h;
  return $map[$y]->[$x];
}

our %rp2Cache;
sub reachablePeaks2 {
  my $loc = $_[0];
  my $h = getAt($loc);

  return $loc if $h == 9;
  return @{$rp2Cache{$loc}} if exists $rp2Cache{$loc};

  my @peaks;
  my @dirs = (-65536, 65536, -1, 1);
  for my $d (@dirs) {
    my $h2 = getAt($loc + $d);
    if($h2 == $h + 1) {
      push @peaks, reachablePeaks2($loc + $d);
    }
  }

  $rp2Cache{$loc} = \@peaks;
  return @peaks;
}
