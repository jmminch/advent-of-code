my $part1;
my $part2;

while(<>) {
  my ($part1d1, $part1d2);
  my ($part2d1, $part2d2);

  # Look for a digit starting at the beginning. Keep chopping off the first
  # character of tmpstr.
  for(my $tmpstr = $_, $part1d1 = -1, $part2d1 = -1;
      length $tmpstr && ($part1d1 == -1 || $part2d1 == -1);
      $tmpstr = substr($tmpstr, 1)) {
    my ($p1, $p2) = convDigit($tmpstr);
    $part1d1 = $p1 if $p1 && $part1d1 == -1;
    $part2d1 = $p2 if $p2 && $part2d1 == -1;
  }

  # Now look for a digit starting at the end.
  for(my $tmpstr = reverse($_), $part1d2 = -1, $part2d2 = -1;
      length $tmpstr && ($part1d2 == -1 || $part2d2 == -1);
      $tmpstr = substr($tmpstr, 1)) {
    my ($p1, $p2) = convDigit_r($tmpstr);
    $part1d2 = $p1 if $p1 && $part1d2 == -1;
    $part2d2 = $p2 if $p2 && $part2d2 == -1;
  }

  $part1 += $part1d1 . $part1d2;
  $part2 += $part2d1 . $part2d2;
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

# These functions take a string and return the digit that the 
# string starts with, if any. Two values are returned--the appropriate
# value for part 1 (just numerical digits) and then the value for part 2
# (including spelled-out digits)
sub convDigit {
  # zero is not used
  my %digits = ( one=>1, two=>2, three=>3, four=>4, five=>5,
                 six=>6, seven=>7, eight=>8, nine=>9 );

  return ($1, $1) if $_[0] =~ /^(\d)/;
  for my $strDigit (keys %digits) {
    return (undef, $digits{$strDigit}) if $_[0] =~ /^$strDigit/;
  }
}

# Convert digits, but reverse the strings for string digits; to use for the
# second digit in part 2.
sub convDigit_r {
  # zero is not used
  my %digits = ( one=>1, two=>2, three=>3, four=>4, five=>5,
                 six=>6, seven=>7, eight=>8, nine=>9 );
  return ($1, $1) if $_[0] =~ /^(\d)/;
  for my $strDigit (keys %digits) {
    my $r = reverse $strDigit;
    return (undef, $digits{$strDigit}) if $_[0] =~ /^$r/;
  }
}
