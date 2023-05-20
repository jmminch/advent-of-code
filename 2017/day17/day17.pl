our $step = shift // 329; # Default value

printf "Part 1 result: %d\n", simulate(2017, 1);
printf "Part 2 result: %d\n", simulate(50000000, 2);

sub simulate {
  my $totalSteps = $_[0];
  my $part = $_[1];
  my @buffer = ( 0 );
  my $bufferSize = 1;
  my $ptr = 0;
  my $part2 = 0;
  for my $i (1..$totalSteps) {
    $ptr = ($ptr + $step) % $bufferSize;
    if($part == 1) {
      # insert $i after element $ptr in @buffer
      splice @buffer, $ptr + 1, 0, $i;
    } else {
      $part2 = $i if $ptr == 0;
    }
    $ptr++;
    $bufferSize++;
  }
  if($part == 1) {
    # Return the value after the last element.
    return $buffer[($ptr + 1) % $bufferSize];
  } else {
    return $part2;
  }
}
