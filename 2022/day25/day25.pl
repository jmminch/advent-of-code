my $sum = 0;
while(<>) {
  chomp;
  $sum += decode($_);
}

print "sum: $sum\n";
print "encoded: ", encode($sum), "\n";

sub decode {
  my $input = $_[0];

  my %digits = ( '=' => -2, '-' => -1, '0' => 0, '1' => 1, '2' => 2 );

  my $sum = 0;

  for $digit (split(//, $input)) {
    $sum *= 5;
    $sum += $digits{$digit};
  }

  return $sum;
}

sub encode {
  my $input = $_[0];

  if($input < 0) {
    print "encoding doesn't work for negative numbers.";
    exit 1;
  }

  # the highest number representable in n digits is 222...n(b5). Figure out
  # how many digits are required to store the input.
  my $base = 0;
  while($base < $input) {
    $base *= 5;
    $base += 2;
  }

  # increment the input by base, then convert to a standard base-5 number.
  $input += $base;

  my @digits = ();

  while($input > 0) {
    unshift @digits, $input % 5;
    $input = int($input / 5);
  }

  my @digitMap = qw(= - 0 1 2);

  return join '', map { $digitMap[$_] } @digits;
}
