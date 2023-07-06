# read input data
while(<>) {
  push @values, int($_) if /\d/;
}

# loop through all pairs of values
LOOP1: for $i (0..$#values) {
  for $j (($i + 1)..($#values)) {
    # if they sum to 2020, report the product and quit.
    if($values[$i] + $values[$j] == 2020) {
      print "part 1 result: ", $values[$i] * $values[$j], "\n";
      last LOOP1;
    }
  }
}

# now loop through all triplets
LOOP2: for $i (0..$#values) {
  for $j (($i + 1)..($#values)) {
    for $k (($j + 1)..($#values)) {
      # if they sum to 2020, report the product and quit.
      if($values[$i] + $values[$j] + $values[$k] == 2020) {
        print "part 1 result: ", $values[$i] * $values[$j] * $values[$k], "\n";
        last LOOP2;
      }
    }
  }
}


