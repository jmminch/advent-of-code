use strict vars;

my $polymer = <>;
chomp $polymer;

# Part 1 - React the polymer and return its length
printf "Part 1 result: %d\n", length(react($polymer));

# Part 2 - Remove all pairs from A/a to Z/z (one at a time) and react the
# result. Determine the minimum resulting length.
my $minLength = 9e100;
for my $let ('a'..'z') {
  my $tmpPoly = $polymer;
  my $ucl = uc $let;
  $tmpPoly =~ s/$let|$ucl//g;
  my $len = length(react($tmpPoly));
  $minLength = $len if $len < $minLength;
}
print "Part 2 result: $minLength\n";

# Eliminate all adjacent instances of a lowercase letter and its
# corresponding uppercase (in either order). Continue to do so until no such
# pairs remain.
sub react {
  my @letters = split //, $_[0];
  my $ptr = 0; # pointer to current character being looked at

  # stop when we hit the last character.
  for(my $ptr = 0; $ptr < $#letters; $ptr++) {
    # If the letters are different, but when compared case-insensitively
    # they are the same, then this pair needs to be removed.
    if($letters[$ptr] ne $letters[$ptr + 1] &&
       lc($letters[$ptr]) eq lc($letters[$ptr + 1])) {
      # Remove two elements
      splice @letters, $ptr, 2;

      # Need to move the pointer backwards to look at the previous unit.
      # (Consider the case of 'aBbA'.) Subtract 2 since the loop increment
      # will increment it again.
      $ptr -= 2;
      $ptr++ if $ptr < -1; # if this was at start of string.
    }
  }

  # Join the letters back into a string.
  return join('', @letters);
}
