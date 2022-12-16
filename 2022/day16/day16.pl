use Data::Dumper;

$maxPressure = -1;
%cache = ( );  # cache of path lengths between points of interest.
$totalTime = 30;  # time limit.  (changes in part 2)

# read the map
while(<>) {
  if(/Valve (\w+) has flow rate=(\d+)/) {
    chomp;
    $v = $1;
    $valves{$v} = [ $2 ];
    # since the description is in English, have to handle the pluralizing...
    s/.*valves? //;
    push @{$valves{$v}}, split(/, /, $_);

    # Record the interesting valves (those with non-zero flow)
    push @nzValves, $v if $valves{$v}->[0];
  }
}

# a little weird because of how I want to use it. arguments are a list and
# an offset. This function will loop through all elements beginning with
# the offset, moving it to that offset, and then recursively call itself
# with offset + 1.
# If at the end of the list, then we've generated a new permutation; call
# the function to process this permutation.
# The "time" parameter is the time value to reach the index before "offset".
# It takes pathlen+1 minutes to reach the next valve.
sub permute {
  my ($list, $offset, $time) = @_;

  if($offset == $#$list || $time > $totalTime) {
    #print "trying ", join('-', @$list), "\n";

    process($list);
  } else {
    # we're going to rotate the last n elements of the list n times, calling
    # permute each time. The last rotate will leave the list in its original
    # state when we return to the caller.
    for my $i ($offset..$#$list) {
      permute($list, $offset + 1, 
              $time + 1 + pathlen($list->[$offset - 1], $list->[$offset]));

      # rotate by removing the element at $offset and appending it.
      my $e = splice(@$list, $offset, 1);
      push @$list, $e;
    }
  }
}

# Given a list of valves, find the total pressure. Record the highest
# pressure found.
sub process {
  my $list = $_[0];
  my $total = 0;
  my $flowrate = 0;
  my $time = 0;

  for $i (1..$#$list) {
    $len = pathlen($list->[$i - 1], $list->[$i]);
    # it takes len minutes to move to the next valve, +1 minute to open it.
    my $dt = $len + 1;
    # make sure that we don't spend more than 30 minutes
    $dt = $totalTime - $time if $time + $dt > $totalTime;
    $total += $flowrate * $dt;
    $time += $dt;

    # increase the flow rate
    $flowrate += $valves{$list->[$i]}->[0];

    last if $time == $totalTime;
  }

  # If all valves were visited before time expired
  if($time < $totalTime) {
    $total += $flowrate * ($totalTime - $time);
  }

  $maxPressure = $total if $total > $maxPressure;
}

sub pathlen {
  my ($p0, $p1) = @_;

  return $cache{"$p0.$p1"} if exists $cache{"$p0.$p1"};

  # search for the shortest path from p0 -> p1.
  my @newsq = ( $p0 );
  my $dist = 0;
  my %visited = ( $p0 => 1 );

  LOOP: while(1) {

    # elements of newsq go into the list of points to search, start a new
    # list.
    my @sq = @newsq;
    @newsq = ();
    $dist++;

    for $sq (@sq) {
      
      for $move (@{$valves{$sq}}) {

        # skip the first entry, the flow rate.
        next if $move =~ /\d/;
        next if exists $visited{$move}; # already checked this valve

        if($move eq $p1) { # found goal
          $cache{"$p0.$p1"} = $dist;
          return $dist;
        }

        $visited{$move} = 1;
        push @newsq, $move;
      }
    }
  }
}

# this generates all permutations that and then calls 'process' for each one;
# process calculates path length and keeps track of the max total
# pressure. Add the starting point 'AA' and start the permutations at offset 1.
unshift @nzValves, 'AA';
permute( \@nzValves, 1, 0 );

print "part 1 result: $maxPressure\n";

# on to part 2.  We're going to divide the set of interesting valves into
# two in all possible ways, and check the total pressure released for the
# best result for each.

$totalTime = 26;
my $totalPressure = -1; # used to store the maximum total pressure found

shift @nzValves; # remove the leading 'AA' used in part 1.

# There are 2^n combinations, but the second half are just inverses of the
# first half, and since swapping the two lists doesn't make a difference,
# only check the first 2^(n-1) combinations.
my $maxbit = 1 << (scalar(@nzValves) - 1);
my $mask = $maxbit - 1;

for(my $bits = 0; $bits < $maxbit; $bits++) {

  my @lists = ( ['AA'], ['AA'] );

  # copy elements to one of the lists; list 0 if the corresponding bit in
  # bits is 0 and list 1 if the bit is 1.
  for my $i (0..$#nzValves) {
    push @{$lists[ ($bits >> $i) & 1 ]}, $nzValves[$i];
  }

  # run permute for both lists.
  $maxPressure = -1;
  permute( $lists[0], 1, 0 );
  my $total = $maxPressure;

  $maxPressure = -1;
  permute( $lists[1], 1, 0 );
  $total += $maxPressure;

  # print join('-', @{$lists[0]}), " ", join('-', @{$lists[1]}), " $total\n";

  $totalPressure = $total if $total > $totalPressure;
}

print "part 2 result: $totalPressure\n";
