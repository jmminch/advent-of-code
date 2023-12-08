use strict vars;
use List::Util qw(reduce);

our %map;
our %rules;

# Read input
while(<>) {
  if(/initial state: ([#\.]+)/) {
    # Set the elements corresponding to '#' in the initial state
    my @state = split //, $1;
    for my $i (0..$#state) {
      $map{$i} = 1 if $state[$i] eq '#';
    }
  } elsif(/([#\.]{5}).*#/) {
    # This captures rules that result in an 'on' cell. If a rule is not in
    # the rules hash, then it results in an 'off' cell.
    $rules{$1} = '#';
  }
}

# Part 1 - simulate 20 generations
my $generation = 0;
for my $i (1..20) {
  step();
  $generation++;
}
printf "Part 1 result: %d\n", sumMap();

# For part 2, experimentation shows that at least with the input given,
# eventually we reach a state where the delta between the sum of two
# generations always remains the same. Track the delta until the sum does
# not change for 100 generations, at which point assume that such a state
# has been found.
my $delta = 0;
my $deltaCount = 0;
my $lastSum = sumMap();
# This code could theoretically work even if there is no loop; it would just
# end up simulating all 50 billion generations.
while($generation < 50e9) {
  step();
  $generation++;

  my $newSum = sumMap();
  if($newSum - $lastSum == $delta) {
    # Same as last delta, increment the counter of how many identical deltas
    # found in a row.
    $deltaCount++;
  } else {
    # Delta changed; reset the counter.
    $delta = $newSum - $lastSum;
    $deltaCount = 0;
  }

  $lastSum = $newSum;
  last if $deltaCount > 100; # probably enough to be sure we've found a loop.
}

my $part2 = $lastSum + $delta * (50e9 - $generation);
print "Part 2 result: $part2\n";

sub sumMap {
  return reduce { $a + $b } keys %map;
}

sub step {
  my %newMap = ( );
  
  # Set all the cells that potentially could be on in the new map to 0
  for my $cell (keys %map) {
    next if !$map{$cell};
    for my $c (($cell-2)..($cell+2)) {
      $newMap{$c} = 0;
    }
  }

  for my $cell (keys %newMap) {
    my $ruleKey = "";
    for my $c (($cell-2)..($cell+2)) {
      $ruleKey .= $map{$c} ? '#' : '.';
    }

    if(exists $rules{$ruleKey}) {
      $newMap{$cell} = 1;
    } else {
      delete $newMap{$cell};
    }
  }

  %map = %newMap;
}
