my $orig = shift // 'hxbxwxba';
my @letters = map { ord($_) - ord('a') } split(//, $orig);
my $valid = 0;

do {

  # increment password.
  $letters[-1]++;
  for(my $i = $#letters; $i > 1; $i--) {
    if($letters[$i] > 25) {
      $letters[$i] = 0;
      $letters[$i - 1]++;
    }
  }
  $letters[0] = 0 if $letters[0] > 25;

  # validity checks
  $valid = 1;

  for my $l (@letters) {
    if($l == (ord('i') - ord('a')) ||
       $l == (ord('o') - ord('a')) ||
       $l == (ord('l') - ord('a'))) {
      $valid = 0;
    }
  }

  if($valid) {
    my $found = 0;
    for my $i (0..$#letters - 2) {
      if($letters[$i] + 1 == $letters[$i+1] &&
         $letters[$i] + 2 == $letters[$i+2]) {
        $found = 1;
        last;
      }
    }
    $valid = 0 if $found == 0;
  }

  if($valid) {
    my %pairs = ();
    for my $i (0..$#letters - 1) {
      if($letters[$i] == $letters[$i+1]) {
        $pairs{$letters[$i]}++;
      }
    }

    $valid = 0 if scalar keys %pairs < 2;
  }

} while(!$valid);

print "part 1 result: ", (map { chr($_+ord('a')) } @letters), "\n";
