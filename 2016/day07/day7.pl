my $part1 = 0;
my $part2 = 0;
while(<>) {
  chomp;
  $part1++ if suppTLS($_);
  $part2++ if suppSSL($_);
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub suppTLS {
  # By using parens in the split, we'll also get the "delimiters"
  # (square-bracketed strings) in our list.
  my @substr = split /(\[[^\]]*\])/, $_[0];

  # look through all substrings. If they're square-bracketed, then return 0
  # if they contain an ABBA string. If they're not, then increment a counter
  # if they contain an ABBA string.
  my $abbaCount = 0;
  for my $s (@substr) {
    if(substr($s, 0, 1) eq '[') {
      return 0 if containsABBA($s);
    } else {
      $abbaCount++ if containsABBA($s);
    }
  }
  return ($abbaCount > 0);
}

sub containsABBA {
  while($_[0] =~ /(.)(.)\2\1/g) {
    return 1 if $1 ne $2;
  }
  return 0;
}

sub suppSSL {
  my @substr = split /(\[[^\]]*\])/, $_[0];

  # look for ABA strings in all non-square-bracketed substrings.
  for my $s1 (@substr) {
    next if substr($s1, 0, 1) eq '[';

    while($s1 =~ /(?=((.)(.)\2))/g) {
      next if $2 eq $3;

      # found an ABA string.
      my $a = $2;
      my $b = $3;
      my $bab = $b . $a . $b;

      # search for any instance of BAB in square-bracketed substrings.
      for my $s2 (@substr) {
        next if substr($s2, 0, 1) ne '[';
        return 1 if index($s2, $bab) >= 0;
      }
    }
  }
  return 0;
}
