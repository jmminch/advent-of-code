my $input = <>;
my @dirs = ( [0,-1], [1,0], [0,1], [-1,0] );
my $x = 0;
my $y = 0;
my $d = 0;

my %locs = ( "0.0" => 1 );
my $part2 = -1;

while($input =~ /(R|L|\d+)/g) {
  if($1 eq 'R') {
    $d = ($d + 1) % 4;
  } elsif($1 eq 'L') {
    $d = ($d - 1) % 4;
  } else {

    for my $step (0..$1 - 1) {
      $x += $dirs[$d]->[0];
      $y += $dirs[$d]->[1];

      if($part2 == -1) {
        if(exists $locs{"$x.$y"}) {
          $part2 = abs($x) + abs($y);
        }
        $locs{"$x.$y"} = 1;
      }
    }
  }
}

print "Part 1 result: ", abs($x) + abs($y), "\n";
print "Part 2 result: $part2\n";
