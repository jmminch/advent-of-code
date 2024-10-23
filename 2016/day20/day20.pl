#!/usr/bin/perl

use strict "vars";

my @rangeList = ( [0, 4294967295] );

while(<>) {
  if(/(\d+)-(\d+)/) {
    my $start = $1;
    my $end = $2;
    my @newRangeList = ();
    for my $range (@rangeList) {
      if($range->[0] > $end || $range->[1] < $start) {
        push @newRangeList, $range;
        next;
      }

      if($range->[0] >= $start && $range->[1] <= $end) {
        next;
      }

      if($range->[1] <= $end && $range->[0] < $start) {
        $range->[1] = $start - 1;
        push @newRangeList, $range;
        next;
      }

      if($range->[0] >= $start && $range->[1] > $end) {
        $range->[0] = $end + 1;
        push @newRangeList, $range;
        next;
      }

      # Must be the case where the blacklist range is fully within this
      # range.
      push @newRangeList, [ $range->[0], $start - 1 ];
      push @newRangeList, [ $end + 1, $range->[1] ];
    }

    @rangeList = @newRangeList;
  }

}

# Part 1 - first value that is still within rangeList.
print "Part 1 result: $rangeList[0]->[0]\n";

# Part 2 - count all values within rangeList
my $count = 0;
for my $range (@rangeList) {
  $count += $range->[1] - $range->[0] + 1;
}

print "Part 2 result: $count\n";
