my $totalTime = shift // 2503;

# read the input data into a table. Note that I don't actually care about
# reindeer names (or reindeer games).
while(<>) {
  if(/fly (\d+) km.s for (\d+) seconds.*rest for (\d+)/) {
    push @deer, [ $1, $2, $3, 0 ];
  }
}

my $maxDist;

# find the positions of every reindeer each second until the total time.
for my $i (1..$totalTime) {
  $maxDist = 0;     # max distance found this second.
  my @maxDeer = (); # this is a list, since there may be ties.

  for my $r (@deer) {
    my ($speed, $flytime, $resttime) = ($r->[0], $r->[1], $r->[2]);
    my $dist = int($i / ($flytime + $resttime)) * ($flytime * $speed);
    my $rtime = $i % ($flytime + $resttime);
    $dist += ($rtime >= $flytime) ? ($flytime * $speed) : ($rtime * $speed);

    if($dist > $maxDist) {
      $maxDist = $dist;
      @maxDeer = ( $r );
    } elsif($dist == $maxDist) {
      push @maxDeer, $r;
    }
  }

  # give the leading deer a point.
  for my $r (@maxDeer) {
    $r->[3]++;
  }
}

print "part 1 result: $maxDist\n";

@deer = sort { $b->[3] <=> $a->[3] } @deer;

print "part 2 result: $deer[0]->[3]\n";
