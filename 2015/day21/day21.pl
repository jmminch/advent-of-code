use Data::Dumper;

# character structures have:
# - hp
# - damage
# - armor
# Returns true if 
sub simCombat {
  my ($char1, $char2, $v) = @_;
  my $hp1 = $char1->{hp};
  my $hp2 = $char2->{hp};

  while($char1->{hp} > 0 && $char2->{hp} > 0) {
    simAttack($char1, $char2);
    last if $char2->{hp} <= 0;
    simAttack($char2, $char1);
  }

  my $rc = ($char1->{hp} > 0);
  $char1->{hp} = $hp1;
  $char2->{hp} = $hp2;

  return $rc;
}

sub simAttack {
  my ($char1, $char2) = @_;
  $dmg = $char1->{damage} - $char2->{armor};
  $dmg = 1 if $dmg < 1;
  $char2->{hp} -= $dmg;
}

my $player = { (hp => 100) };
my $boss = { (hp => 100, damage => 8, armor => 2) };

# These are all the weapons in the shop
my @weapList = (
  [ 8, 4, 0 ],
  [ 10, 5, 0 ],
  [ 25, 6, 0 ],
  [ 40, 7, 0 ],
  [ 74, 8, 0 ] );

my @armorList = (
  [ 0, 0, 0 ],  # dummy for no armor
  [ 13, 0, 1 ],
  [ 31, 0, 2 ],
  [ 53, 0, 3 ],
  [ 75, 0, 4 ],
  [ 102, 0, 5 ] );

my @ringList = (
  [ 25, 1, 0 ],
  [ 50, 2, 0 ],
  [ 100, 3, 0 ],
  [ 20, 0, 1 ],
  [ 40, 0, 2 ],
  [ 80, 0, 3 ] );

my $minCost = 999999;
my $maxCost = -1;

# Try all combinations. Loop through all combinations of weapon and armor,
# and then each combination of 0-2 rings.
for my $weap (@weapList) {
  for my $armor (@armorList) {
    
    # no ring
    my $cost1 = $weap->[0] + $armor->[0];
    next if $cost1 >= $minCost;

    $player->{damage} = $weap->[1];
    $player->{armor} = $armor->[2];
    if(simCombat($player, $boss)) {
      $minCost = $cost1 if $cost1 < $minCost;
    } else {
      $maxCost = $cost1 if $cost1 > $maxCost;
    }

    # one ring
    for my $ring (@ringList) {
      my $cost2 = $cost1 + $ring->[0];
      next if $cost2 >= $minCost;
      $player->{damage} = $weap->[1] + $ring->[1];
      $player->{armor} = $armor->[2] + $ring->[2];
      if(simCombat($player, $boss)) {
        $minCost = $cost2 if $cost2 < $minCost;
      } else {
        $maxCost = $cost2 if $cost2 > $maxCost;
      }
    }

    # two rings
    for my $i (0..($#ringList - 1)) {
      for my $j (($i + 1)..$#ringList) {
        my $cost2 = $cost1 + $ringList[$i]->[0] + $ringList[$j]->[0];
        next if $cost2 >= $minCost;
        $player->{damage} = $weap->[1] +
                            $ringList[$i]->[1] + $ringList[$j]->[1];
        $player->{armor} = $armor->[2] +
                           $ringList[$i]->[2] + $ringList[$j]->[2];
        if(simCombat($player, $boss)) {
          $minCost = $cost2 if $cost2 < $minCost;
        } else {
          $maxCost = $cost2 if $cost2 > $maxCost;
        }
      }
    }
  }
}

print "part 1 result: $minCost\n";
print "part 2 result: $maxCost\n";
