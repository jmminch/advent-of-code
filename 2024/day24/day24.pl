#!/usr/bin/perl

use strict vars;

our %wires = ( );

while(<>) {
  if(/^(\w+): (\d)/) {
    $wires{$1} = [ $2, int($2) ];
  } elsif(/^(\w+) (AND|OR|XOR) (\w+) -> (\w+)/) {
    $wires{$4} = [ [ $2, $1, $3 ], undef ];
  }
}

my $part1;
for my $w (reverse sort(grep(/^z/, keys %wires))) {
  $part1 *= 2;
  $part1 += wireValue($w);
}

print "Part 1 result: $part1\n";

sub wireValue {
  my $w = $_[0];

  return $wires{$w}->[1] if defined($wires{$w}->[1]);
  
  my $r;

  if($wires{$w}->[0]->[0] eq 'AND') {
    $r = wireValue($wires{$w}->[0]->[1]) & wireValue($wires{$w}->[0]->[2]);
  } elsif($wires{$w}->[0]->[0] eq 'OR') {
    $r = wireValue($wires{$w}->[0]->[1]) | wireValue($wires{$w}->[0]->[2]);
  } elsif($wires{$w}->[0]->[0] eq 'XOR') {
    $r = wireValue($wires{$w}->[0]->[1]) ^ wireValue($wires{$w}->[0]->[2]);
  } else {
    die;
  }

  $r = int($r);
  $wires{$w}->[1] = $r;
  return $r;
}
