# read records ("groups") which are separated by blank lines
$/ = "\n\n";
while(<>) {
  my @forms = split /\n/; # this is just to get the number of people
                          # in the group.

  # the %resp hash will have the number of 'yes' answers for each question
  my %resp = ( );
  s/[^a-z]//g;
  for my $ans (split //) {
    $resp{$ans}++;
  }

  $part1 += scalar keys %resp; # count of unique answers
  for $val (values %resp) {
    $part2++ if $val == scalar @forms; # count of answers shared by all forms
  }
}

print "part 1 result: $part1\n";
print "part 2 result: $part2\n";
