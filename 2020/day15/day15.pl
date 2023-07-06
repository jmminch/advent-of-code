my @input = (10,16,6,0,1,17);  # puzzle input
# create a table of the turn # when each number was said
for my $t (0..$#input) {
  $history{$input[$t]} = $t;
}

$next = 0;
$turn = scalar @input;
for($turn = scalar @input; $turn < 30000000 - 1; $turn++) {
  if($turn == 2019) {
    # part 1
    print "part 1 result: $next\n";
  }

  $new = exists $history{$next} ? ($turn - $history{$next}) : 0;
  $history{$next} = $turn;
  $next = $new;
}

print "part 2 result: $next\n";
