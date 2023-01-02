use Data::Dumper;

$bossdmg = 8;
$hardMode = 0;

my $startState = { ( hp=>50, mana=>500, bosshp=>55 ) };
my $part1 = search($startState);
print "part 1 result: $part1\n";
$hardMode = 1;
my $part2 = search($startState);
print "part 2 result: $part2\n";

sub stateKey {
  my $state = $_[0];

  my $key = int($state->{shield});
  $key = ($key << 3) | ($state->{poison});
  $key = ($key << 3) | ($state->{recharge});
  $key = ($key << 12) | ($state->{hp});
  $key = ($key << 12) | ($state->{mana});
  $key = ($key << 12) | ($state->{bosshp});
}

sub search {
  my $startState = $_[0];  
  my $minMana = 9999999;
  my $minState;

  my %stateCache = ( stateKey($startState) => 0 );
  my @stateList = ( $startState );

  while(1) {
    my $state = shift @stateList;
    last if $state->{manause} >= $minMana;

    # try all possible actions.
    for my $act (0..4) {
      my $newState = doAction($state, $act);
      next if !ref $newState; # invalid
      next if $newState->{hp} < 1;  # player would die
      if($newState->{bosshp} < 1) {
        if($newState->{manause} < $minMana) {
          $minState = $newState;
          $minMana = $newState->{manause};
        }
        next;
      }

      my $key = stateKey($newState);
      if(exists $stateCache{$key}) {
        if($stateCache{$key} <= $newState->{manause}) {
          next;
        }
      }
      $stateCache{$key} = $newState->{manause};

      # add the new state to the queue of ones to try. The list is sorted in
      # order of increasing manause.
      my $idx;
      for($idx = 0; $idx <= $#stateList &&
                    $stateList[$idx]->{manause} < $newState->{manause};
                    $idx++) { }
      splice @stateList, $idx, 0, $newState;
    }
  }

  return $minMana;
}

sub doAction {
  my ($state, $action) = @_;
  my $newState = { (%$state) };
  my $shield = 0;

  if($hardMode) {
    $newState->{hp}--;
    return $newState if $newState->{hp} < 1;
  }

  # apply effects for start of player turn
  if($newState->{shield} > 0) {
    $shield = 1;
    $newState->{shield}--;
  }

  if($newState->{poison} > 0) {
    $newState->{bosshp} -= 3;
    $newState->{poison}--;
  }

  if($newState->{recharge} > 0) {
    $newState->{mana} += 101;
    $newState->{recharge}--;
  }

  return $newState if $newState->{bosshp} < 1;

  $newState->{actions} .= $action;

  # handle the action.
  if($action == 0) {
    $newState->{bosshp} -= 4;
    $newState->{mana} -= 53;
    $newState->{manause} += 53;
  } elsif($action == 1) {
    $newState->{bosshp} -= 2;
    $newState->{hp} += 2;
    $newState->{mana} -= 73;
    $newState->{manause} += 73;
  } elsif($action == 2) {
    return -1 if $newState->{shield} > 0;
    $newState->{shield} = 6;
    $newState->{mana} -= 113;
    $newState->{manause} += 113;
  } elsif($action == 3) {
    return -1 if $newState->{poison} > 0;
    $newState->{poison} = 6;
    $newState->{mana} -= 173;
    $newState->{manause} += 173;
  } elsif($action == 4) {
    return -1 if $newState->{recharge} > 0;
    $newState->{recharge} = 5;
    $newState->{mana} -= 229;
    $newState->{manause} += 229;
  }

  return -1 if $newState->{mana} < 0;

  return $newState if $newState->{bosshp} < 1;

  # apply effects for start of boss turn
  if($newState->{shield} > 0) {
    $shield = 1;
    $newState->{shield}--;
  }

  if($newState->{poison} > 0) {
    $newState->{bosshp} -= 3;
    $newState->{poison}--;
  }

  if($newState->{recharge} > 0) {
    $newState->{mana} += 101;
    $newState->{recharge}--;
  }

  return $newState if $newState->{bosshp} < 1;

  # apply boss' attack
  my $dmg = $bossdmg;
  $dmg -= 7 if $shield;
  $dmg = 1 if $dmg < 1;
  $newState->{hp} -= $dmg;

  return $newState if $newState->{hp} < 1;

  if($hardMode) {
    $newState->{hp}--;
    return $newState if $newState->{hp} < 1;
  }

  return $newState;
}
