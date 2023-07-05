# read rules
while(<>) {
  if(/^([a-z ]*) bags contain/) {
    my $bag = $1;
    while(/ (\d+) ([a-z ]+) bag/g) {
      push @{$rules{$bag}}, [ $1, $2 ];
    }
  }
}

# find anything that can contain shiny gold bags.
my @check = ( "shiny gold" );
while(scalar @check > 0) {
  $bag = shift @check;
  for $key (keys %rules) {
    next if exists $parents{$key};
    for $rule (@{$rules{$key}}) {
      if($rule->[1] eq $bag) {
        push @check, $key;
        $parents{$key} = 1;
        last;
      }
    }
  }
}
delete $parents{"shiny gold"};  # shouldn't count this one.

printf "part 1 result: %d\n", scalar keys %parents;

# now find out how many bags a shiny gold bag contains.
printf "part 2 result: %d\n", contents("shiny gold");

sub contents {
  my $type = $_[0];
  my $total = 0;
  for $rule (@{$rules{$type}}) {
    # note that the extra one is for the bag itself, since contents only
    # returns what it contains.
    $total += $rule->[0] * (1 + contents($rule->[1]));
  }
  return $total;
}
