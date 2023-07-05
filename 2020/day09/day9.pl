my $preamble = shift // 25;

@values = <>;
chomp @values;

my $invalid = findInvalid($preamble);
my $part2 = findContig($invalid);

print "part 1 result: $invalid\n";
print "part 2 result: $part2\n";

sub findInvalid {
  my $preamble = $_[0];
  for(my $idx = $preamble; $idx <= $#values; $idx++) {
    # check whether $values[$idx] is the sum of two of the preceding values.
    my $valid = 0;
    LOOP: for my $i (($idx - $preamble) .. ($idx - 2)) {
      for my $j (($i + 1) .. ($idx - 1)) {
        if($values[$i] + $values[$j] == int($values[$idx])) {
          $valid = 1;
          last LOOP;
        }
      }
    }
    return $values[$idx] if !$valid;
  }
  die "invalid input";
}

sub findContig {
  my $target = $_[0];
  for my $i (0..$#values) {
    my $tot = $values[$i];
    for my $j (($i + 1)..$#values) {
      $tot += $values[$j];
      last if $tot > $target;
      if($tot == $target) {
        # find smallest and largest in this range.
        my $smallest = 999999999;
        my $largest = -999999999;
        for my $k ($i..$j) {
          $smallest = $values[$k] if $values[$k] < $smallest;
          $largest = $values[$k] if $values[$k] > $largest;
        }

        return $smallest + $largest;
      }
    }
  }
}
