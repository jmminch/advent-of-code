# Read in the captcha string and remove all non-digit characters.
my $captcha = shift // <>;
$captcha =~ s/[^\d]//g;

# sum(s, n) -- calculate the sum of all digits of the string s (s[x]) that
# are the same as s[x+n].
sub sum {
  my $r = 0;
  for my $i (0..length($_[0]) - 1) {
    $r += substr($_[0], $i, 1) if
      substr($_[0], $i, 1) eq substr($_[0], ($i + $_[1]) % length($_[0]), 1);
  }
  return $r;
}

# part 1 is the sum using the next character for each digit (n=1).
# part 2 is the sum for the character halfway around the list (n=(len s) / # 2).
printf "Part 1 result: %d\n", sum($captcha, 1);
printf "Part 2 result: %d\n", sum($captcha, length($captcha) / 2);
