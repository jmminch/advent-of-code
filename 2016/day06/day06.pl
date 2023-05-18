# Create a list of hashes. Each element of the list represents character
# frequencies at that position.

my @freq;

# Read all lines
while(<>) {
  chomp;
  # process each line character-by-character
  my @chars = split //;
  for my $i (0..$#chars) {
    $freq[$i]->{$chars[$i]}++;
  }
}

# part 1 is the most frequent character in each list; part 2 is least
# frequent.
my ($part1, $part2);

# Go through the freq array position by position.
for my $freq (@freq) {
  my $max = -1;
  my $min = 99999;
  my ($maxChar, $minChar);

  for my $let (keys %$freq) {
    if($freq->{$let} > $max) {
      $max = $freq->{$let};
      $maxChar = $let;
    }

    if($freq->{$let} < $min) {
      $min = $freq->{$let};
      $minChar = $let;
    }
  }

  $part1 .= $maxChar;
  $part2 .= $minChar;
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
