#!/usr/bin/perl

use strict vars;

my $w = 101;
my $h = 103;

my @robots;

while(<>) {
  next if !/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/;
  push @robots, [ $1, $2, $3, $4 ];
}

for my $t (0..6620) {
  print "time=$t\n";

  # record positions of all robots in a hash and then move the robots.
  my %robotPos = ( );
  for my $r (@robots) {
    $robotPos{$r->[0] . "," . $r->[1]} = 1;
    $r->[0] = ($r->[0] + $r->[2]) % $w;
    $r->[1] = ($r->[1] + $r->[3]) % $h;
  }

  # Display the room.
  for my $y (0..$h) {
    for my $x (0..$w) {
      print ($robotPos{"$x,$y"} ? '#' : ' ');
    }
    print "\n";
  }
  print "\n";
}
