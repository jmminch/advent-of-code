use strict vars;

# Read all box IDs.
my @boxes = <>;
chomp @boxes;

# Part 1
my ($count2, $count3);
for my $box (@boxes) {
  # Count each distinct letter in $box
  my %counts;
  for my $let (split //, $box) {
    $counts{$let}++;
  }

  # Determine if the values 2 and 3 are present in the %counts hash.
  my ($has2, $has3);
  for my $val (values %counts) {
    $has2 = 1 if $val == 2;
    $has3 = 1 if $val == 3;
  }

  # Increment the counters if appropriate
  $count2++ if $has2;
  $count3++ if $has3;
}

printf "Part 1 result: %d\n", $count2 * $count3;


# Part 2
LOOP: for my $i (0..$#boxes) {
  for my $j (($i+1)..$#boxes) {
    my $r = compareBox($boxes[$i], $boxes[$j]);
    if($r) {
      print "Part 2 result: $r\n";
      last LOOP;
    }
  }
}

# If the box IDs are "similar" (only one character difference), then return
# the string of all identical characters. Else return false.
sub compareBox {
  my @b1 = split //, $_[0];
  my @b2 = split //, $_[1];
  my $r;

  for my $i (0..$#b1) {
    $r .= $b1[$i] if $b1[$i] eq $b2[$i];
  }

  return (length $r < length($_[0]) - 1) ? 0 : $r;
}
