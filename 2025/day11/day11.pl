#!/usr/bin/perl

use strict vars;
use Memoize;

memoize('numPaths');

my %nodes;

while(<>) {
  $nodes{$1} = [ split / /, $2 ] if /^(.*): ([a-z ]*)/;
}

printf "Part 1 result: %d\n", numPaths('you', 'out');
printf "Part 2 result: %d\n",
  numPaths('svr', 'fft') * numPaths('fft', 'dac') * numPaths('dac', 'out') +
  numPaths('svr', 'dac') * numPaths('dac', 'fft') * numPaths('fft', 'out');

sub numPaths {
  return 1 if $_[0] eq $_[1];
  my $r = 0;
  for my $n (@{$nodes{$_[0]}}) {
    $r += numPaths($n, $_[1]);
  }
  return $r;
}
