# the input lines are binary numbers, with 'B' and 'R' representing 1 and
# 'F' and 'L' representing 0.
while(<>) {
  chomp;
  my $seat = 0;
  for(my $bit = 512; $bit > 0; $bit >>= 1) {
    $ch = substr($_, 0, 1, '');
    $seat += $bit if $ch eq 'B' or $ch eq 'R';
  }
  push @seats, $seat;
}

# part 1: the maximum seat number.
@seats = sort { $a <=> $b } @seats;
printf "part 1 result: %d\n", $seats[-1];

# part 2: find a seat number that is missing, but the ones before and after
# it are present.
for(my $idx = 0; $idx <= $#seats - 1; $idx++) {
  if($seats[$idx] == $seats[$idx + 1] - 2) {
    printf "part 2 result: %d\n", $seats[$idx] + 1;
    last;
  }
}
