#!/usr/bin/perl

use strict vars;
use Memoize;

memoize('findPattern');

my $line = <>;
my @towels;
push @towels, $1 while $line =~ /(\w+)/g;

my $part1;
my $part2;
while(<>) {
  chomp;
  next if !/\w/;

  my $r = findPattern(\@towels, $_, 0);
  $part1++ if $r;
  $part2 += $r;
}
print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub findPattern {
  my ($towels, $str, $offset) = @_;

  return 1 if $offset == length $str;

  my $sum = 0;
  for my $t (@$towels) {
    if($t eq substr($str, $offset, length $t)) {
      $sum += findPattern($towels, $str, $offset + length $t);
    }
  }
  return $sum;
}
