#!/usr/bin/perl

use strict vars;

# The format of pointers into a list of values:
# (array index << 8) | position

my @map = split //, <>;

# Create a list of all files.
my @fileList;
for(my $i = 0; $i <= $#map; $i += 2) {
  push @fileList, $map[$i];
}

# Generate the checksum by stepping through the disk positions and
# determining which file block should be at each position.
my $blockIdx = 0;
my $diskPtr = 0;
my $startPtr = 0;
my $endPtr = ($#fileList << 8) | ($fileList[$#fileList] - 1);
my $empty = 0;
my $ckSum = 0;

LOOP: while($startPtr <= $endPtr) {
  for my $i (1..$map[$diskPtr]) {

    if($empty) {
      # Take from the end.
      $ckSum += $blockIdx * ($endPtr >> 8);
      if(($endPtr & 0xFF) == 0) {
        $endPtr -= 256;
        $endPtr |= ($fileList[$endPtr >> 8] - 1);
      } else {
        $endPtr--;
      }
    } else {
      # Take from the start.
      $ckSum += $blockIdx * ($startPtr >> 8);
      $startPtr++;
      if(($startPtr & 0xFF) == $fileList[$startPtr >> 8]) {
        $startPtr &= ~0xFF;
        $startPtr += 256;
      }
    }
    $blockIdx++;

    last if $startPtr > $endPtr;
  }
  $empty = !$empty;
  $diskPtr++;
}

print "Part 1 result: $ckSum\n";

# For part 2, I want a map of the disk locations of each file and empty
# space.
my @fileMap;
my @freeMap;
$blockIdx = 0;
for my $i (0..$#map) {
  if($i & 1) {
    push @freeMap, [ $blockIdx, $map[$i] ];
  } else {
    push @fileMap, [ $blockIdx, $map[$i], ($i >> 1) ];
  }

  $blockIdx += $map[$i];
}

# For each file, try to move it into free space with a lower block idx.
for my $file (reverse @fileMap) {
  for my $free (@freeMap) {
    last if $free->[0] > $file->[0]; # check block idx
    next if $free->[1] < $file->[1]; # check size of free space

    # Found a good position.
    $file->[0] = $free->[0];
    $free->[0] += $file->[1];
    $free->[1] -= $file->[1];
  }
}

# Now go through the file map and calculate the checksums.
my $part2 = 0;
for my $file (@fileMap) {
  for my $i (0..$file->[1] - 1) {
    $part2 += ($file->[0] + $i) * $file->[2];
  }
}
print "Part 2 result: $part2\n";
