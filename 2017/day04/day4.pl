while(<>) {
  # Each line is a whitespace-delimited list of words.
  my @words = split /\s+/;

  # check for any duplicate words.
  for my $i (0..$#words) {
    for my $j ($i+1..$#words) {
      goto dup if($words[$i] eq $words[$j]);
    }
  }

  # no duplicate words.
  $part1++;

  dup:

  # sort the letters in each word in alphabetical order.
  for my $i (0..$#words) {
    my @chars = split //, $words[$i];
    $words[$i] = join '', sort(@chars);
  }

  # check again for any duplicate words.
  for my $i (0..$#words) {
    for my $j ($i+1..$#words) {
      goto dup2 if($words[$i] eq $words[$j]);
    }
  }

  # no duplicate words.
  $part2++;

  dup2:
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
