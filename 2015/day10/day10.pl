my $input = shift // '1321131112';

sub generate {
  my $input = $_[0];
  my $output = '';
  my $ip = 0;

  # repeatedly find out how long the run starting at ip is, and then add the
  # length + the digit to output; then increment ip to be after the run.
  # We're done when ip is beyond the length of input.

  while($ip < length $input) {
    my $digit = substr $input, $ip, 1;
    my $run = 1;
    while($run + $ip < length $input &&
          substr($input, $ip + $run, 1) eq $digit) {
      $run++;
    }

    $output .= $run . $digit;
    $ip += $run;
  }

  return $output;
}

for my $i (1..40) {
  $input = generate($input);
}

print "Part 1 result: ", length $input, "\n";

# 10 more times for part 2.

for my $i (1..10) {
  $input = generate($input);
}

print "Part 2 result: ", length $input, "\n";
