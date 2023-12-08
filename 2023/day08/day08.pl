use strict vars;
use Data::Dumper;

# Read the input data.
my @instructions;
my %nodes;
while(<>) {
  chomp;
  if(/^[LR]+$/) {
    tr/LR/01/;
    @instructions = split //;
  } elsif(/(\w+) = \((\w+), (\w+)\)/) {
    $nodes{$1} = [ $2, $3 ];
  }
}

# Follow the instructions until reaching node 'ZZZ'
my $steps = 0;
my $ptr = 0; # pointer into @instructions array
my $node = 'AAA';
while($node ne 'ZZZ') {
  $node = $nodes{$node}->[$instructions[$ptr]];
  $ptr++;
  $ptr = 0 if $ptr > $#instructions;
  $steps++;
}
print "Part 1 result: $steps\n";

# For part 2, find all nodes that end with 'A'.
my @nodeList = sort grep /A$/, keys %nodes;
my @loopList;

# For each node in this list, find a loop in the state.
for my $i (0..$#nodeList) {
  my $node = $nodeList[$i];
  my $steps = 0;
  my $ptr = 0;
  my $foundNode;
  my $foundStep = 0;

  while(1) {
    $node = $nodes{$node}->[$instructions[$ptr]];
    $ptr++;
    $ptr = 0 if $ptr > $#instructions;
    $steps++;
    if($node =~ /Z$/) {
      die if $foundStep && $foundNode ne $node; # this case isn't handled
      last if $foundStep; # found a loop
      $foundNode = $node;
      $foundStep = $steps;
    }
  }

  # found the loop.
  # Note that all loops for the input have the same loop length as the step
  # number that they start on, so the loop length is actually just the step
  # number where a 'Z' node was first found.
  $loopList[$i] = $steps - $foundStep; # loop length.

  # The loop lengths are all multiples of the length of the instruction
  # list.
  $loopList[$i] /= scalar @instructions;
}

# The solution for part 2 is the number of instructions times all of the
# loop lengths.
my $part2 = scalar @instructions;
for my $l (@loopList) { $part2 *= $l; }

print "Part 2 result: $part2\n";
