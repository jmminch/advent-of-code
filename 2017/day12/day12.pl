use strict 'vars';

our $groupId = 1; # next group id to assign
our %groups;

while(<>) {
  # All I need is a list of the numbers on the line; all of those nodes are
  # connected together.
  my @nodes = split /[^\d]+/;

  # Get the group for the first node; possibly creating it
  my $group = getGroup($nodes[0]);

  for my $id (@nodes) {
    # Combine any other groups into the one for the first node.
    next if $id == $nodes[0];
    my $group2 = getGroup($id);
    combineGroup($group, $group2) if $group != $group2;
  }
}

# For part 1, how many nodes are in the group with node 0?
my $group = getGroup(0);
printf "Part 1 result: %d\n", scalar @{$groups{$group}};

# For part 2, how many groups are there?
printf "Part 2 result: %d\n", scalar keys %groups;

sub getGroup {
  my $node = $_[0];

  # search for this node among the groups.
  for my $group (keys %groups) {
    for my $groupNode (@{$groups{$group}}) {
      return $group if($node == $groupNode);
    }
  }

  # not found, create a new group.
  $groups{$groupId} = [ $node ];
  $groupId++;
  return $groupId - 1;
}

sub combineGroup {
  my ($group1, $group2) = @_;
  push @{$groups{$group1}}, @{$groups{$group2}};
  delete $groups{$group2};
}
