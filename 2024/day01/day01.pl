#!/usr/bin/perl

my (@list1, @list2);

# Read both lists. Each line of input has two numbers; one entry for list 1
# and one entry for list 2.
while(<>) {
  if(/(\d+)\s+(\d+)/) {
    push @list1, $1;
    push @list2, $2;
  }
}

# Sort both lists
@list1 = sort { $a <=> $b } @list1;
@list2 = sort { $a <=> $b } @list2;

my $part1 = 0;
for my $i (0..$#list1) {
  $part1 += abs($list1[$i] - $list2[$i]);
}

print "Part 1 result: $part1\n";

# Create a hash of the frequency of each number in list 2.
my %list2Freq;
for my $x (@list2) {
  $list2Freq{$x}++;
}

# The "similarity score" for each entry in list 1 is the value of the entry,
# times the number of times it appears in list 2. Calculate the sum of all
# similarity scores for part 2.
my $part2 = 0;
for my $x (@list1) {
  $part2 += $x * $list2Freq{$x};
}

print "Part 2 result: $part2\n";
