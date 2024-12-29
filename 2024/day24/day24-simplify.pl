#!/usr/bin/perl

use strict vars;

our %wires = ( );
my @swaps = ( );

while(<>) {
  if(/^(\w+): (\d)/) {
    $wires{$1} = [ $2, int($2) ];
  } elsif(/SWAP (\w+) AND (\w+)/) {
    push @swaps, [ $1, $2 ];
  } elsif(/^(\w+) (AND|OR|XOR) (\w+) -> (\w+)/) {

    # Sort input gates in order.
    my $w0 = $1;
    my $w1 = $3;
    if($w0 gt $w1) {
      $w0 = $3;
      $w1 = $1;
    }

    $wires{$4} = [ [ $2, $w0, $w1 ], undef ];
  }
}

# Assume that we have:
# S1N = xN XOR yN
# SN = C(N-1) XOR S1N
# C1N = xN AND yN
# C2N = C(N-1) AND S1N
# CN = C1N OR C2N
# Try to identify which wire is which.

my %parts;

for my $i (0..44) {
  # Find all the xN XOR yN gates to identify the S1N outputs.
  # Find all the xN AND yN gates to identify the C1N outputs.
  for my $w (keys %wires) {
    my $def = $wires{$w}->[0];
    if($def->[0] eq 'XOR' && $def->[1] eq sprintf('x%.2d', $i)) {
      $parts{"S1-$i"} = $w;
    }

    if($def->[0] eq 'AND' && $def->[1] eq sprintf('x%.2d', $i)) {
      $parts{"C1-$i"} = $w;
      $parts{"C-$i"} = $w if $i == 0;
    }
  }

  # Look for S-N and C2-N, which is C-(N-1) XOR/AND S1-N 
  my $w1 = $parts{sprintf "C-%d", $i - 1};
  my $w2 = $parts{"S1-$i"};
  if($w1 gt $w2) {
    my $t = $w1;
    $w1 = $w2;
    $w2 = $t;
  }

  for my $w (keys %wires) {
    my $def = $wires{$w}->[0];
    if($def->[0] eq 'XOR' && $def->[1] eq $w1 && $def->[2] eq $w2) {
      $parts{"S-$i"} = $w;
    }
    if($def->[0] eq 'AND' && $def->[1] eq $w1 && $def->[2] eq $w2) {
      $parts{"C2-$i"} = $w;
    }
  }

  $w1 = $parts{"C1-$i"};
  $w2 = $parts{"C2-$i"};
  if($w1 gt $w2) {
    my $t = $w1;
    $w1 = $w2;
    $w2 = $t;
  }

  for my $w (keys %wires) {
    my $def = $wires{$w}->[0];
    if($def->[0] eq 'OR' && $def->[1] eq $w1 && $def->[2] eq $w2) {
      $parts{"C-$i"} = $w;
    }
  }
}

for my $i (0..44) {
  if(exists $parts{"S1-$i"}) {
    my $w = $parts{"S1-$i"};
    print "S1-$i: $wires{$w}->[0]->[1] $wires{$w}->[0]->[0] $wires{$w}->[0]->[2] -> $w\n";
  }
}

for my $i (0..44) {
  if(exists $parts{"C1-$i"}) {
    my $w = $parts{"C1-$i"};
    print "C1-$i: $wires{$w}->[0]->[1] $wires{$w}->[0]->[0] $wires{$w}->[0]->[2] -> $w\n";
  }
}

for my $i (0..44) {
  if(exists $parts{"S-$i"}) {
    my $w = $parts{"S-$i"};
    print "S-$i: $wires{$w}->[0]->[1] $wires{$w}->[0]->[0] $wires{$w}->[0]->[2] -> $w\n";
  }
}

for my $i (0..44) {
  if(exists $parts{"C-$i"}) {
    my $w = $parts{"C-$i"};
    print "C-$i: $wires{$w}->[0]->[1] $wires{$w}->[0]->[0] $wires{$w}->[0]->[2] -> $w\n";
  }
}



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
