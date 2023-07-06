use List::Util qw(max);

# Read the input, a whitespace-delimited list of integers on a single line.
$_ = <>;
chomp;
my @banks = split /\s+/;
my $turn = 0;

while(1) {
  
  # perform the redistribution.
  # 1. find the bank with the largest number. If multiple banks are equal,
  #    choose the first in the array.
  my $max = max @banks;
  my $idx = 0;
  for($idx = 0; $idx <= $#banks; $idx++) {
    last if $banks[$idx] == $max;
  }

  # 2. Remove everything from $banks[$idx];
  my $count = $banks[$idx];
  $banks[$idx] = 0;

  # 3. Start from the next index and place 1 in each bank until exhausting
  #    count. Wrap around when reaching the end.
  for(my $i = $idx + 1; $count > 0; $i++, $count--) {
    $i = 0 if $i > $#banks;
    $banks[$i]++;
  }

  $turn++;

  # redistribution is done. Create a key for this state.
  my $state = join '.', @banks;

  if(exists $cache{$state}) {
    # loop found!
    print "Part 1 result: $turn\n";
    printf "Part 2 result: %d\n", $turn - $cache{$state};
    exit 0;
  } else {
    $cache{$state} = $turn;
  }
}
