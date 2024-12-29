#!/usr/bin/perl

use strict vars;

my @locks;
my @keys;

$/ = "\n\n";
while(<>) {
  my @lines = split /\n/;
  my @pins = ( );
  my $key;
  if($lines[6] =~ /^#/) {
    $key = 1;
    @lines = reverse @lines;
  }

  for(my $i = 5; $i >= 0; $i--) {
    my @chars = split //, $lines[$i];
    for my $j (0..$#chars) {
      if(!defined($pins[$j]) && $chars[$j] eq '#') {
        $pins[$j] = $i;
      }
    }
  }

  if($key) {
    push @keys, \@pins;
  } else {
    push @locks, \@pins;
  }
}

my $part1 = 0;
for my $lock (@locks) {
  for my $key (@keys) {
    my $fit = 1;
    for my $i (0..4) {
      if($lock->[$i] + $key->[$i] > 5) {
        $fit = 0;
        last;
      }
    }
    $part1 += $fit;
  }
}

print "Part 1 result: $part1\n";
