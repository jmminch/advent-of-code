#!/usr/bin/perl

use strict vars;

# Read all the data
my @map = <>;
chomp @map;

# Create a hash where the keys corresponding to the locations of all '@'
# characters are set. The key is 1000*y + x + 500
my %map;
for my $y (0..$#map) {
  my @chars = split //, $map[$y];
  for my $x (0..$#chars) {
    $map{$y * 1000 + $x + 500} = 1 if $chars[$x] eq '@';
  }
}

my @dirs = ( -1001, -1000, -999, -1, 1, 999, 1000, 1001 );

# Count the number of neighbors at each location.
my $part1 = 0;
my (%counts, %q);

for my $loc (keys %map) {
  my $count = 0;
  for my $d (@dirs) {
    $count++ if exists $map{$loc + $d};
  }
  $part1++ if $count < 4;
  $counts{$loc} = $count;
  $q{$loc} = 1;
}

my $part2 = 0;
my @q = keys %q;
while(my $loc = shift @q) {
  delete $q{$loc};
  if($counts{$loc} < 4) {
    $part2++;
    delete $map{$loc};
    for my $d (@dirs) {
      if($map{$loc + $d}) {
        $counts{$loc + $d}--;
        if(not exists $q{$loc + $d}) {
          push @q, $loc + $d;
          $q{$loc + $d} = 1;
        }
      }
    }
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
