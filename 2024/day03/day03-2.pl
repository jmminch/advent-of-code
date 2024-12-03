#!/usr/bin/perl

use strict vars;

# Slurp entire input into a string.
my $input;
{ local $/; $input = <>; }

printf "Part 1 result: %d\n", mulTotal($input);
$input =~ s/don't\(\).*?(do\(\)|$)/XXX/gs;
printf "Part 2 result: %d\n", mulTotal($input);

sub mulTotal {
  $_ = $_[0];
  my $r = 0;
  while(/mul\((\d{1,3}),(\d{1,3})\)/g) {
    $r += $1 * $2;
  }
  return $r;
}
