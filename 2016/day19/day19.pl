#!/usr/bin/perl

use strict 'vars';

my $elves = shift // 3014387;

# part 1
my ($elfList, $elfPtr) = buildElfList($elves);
while(elfListLen($elfList) > 1) {
  steal($elfList, $elfPtr, 1);
  $elfPtr = findNextElf($elfList, $elfPtr, 1);
}
printf "Part 1 result: %d\n", $elfPtr->{elf};

# part 2
# reset elfList and elfPtr
($elfList, $elfPtr) = buildElfList($elves);
while(elfListLen($elfList) > 1) {
  steal($elfList, $elfPtr, int(elfListLen($elfList) / 2));
  $elfPtr = findNextElf($elfList, $elfPtr, 1);
}
printf "Part 2 result: %d\n", $elfPtr->{elf};

# sub buildElfList {
#   my @elfList;
#   for my $elf (1 .. $_[0]) {
#     push @elfList, $elf;
#   }
# 
#   return (\@elfList, 0);
# }
# 
# sub elfListLen {
#   return scalar(@{$_[0]});
# }
# 
# sub findNextElf {
#   my ($elfList, $elfPtr, $step) = @_;
#   my $newElf = $elfPtr + $step;
#   $newElf -= scalar(@$elfList) if $newElf >= scalar(@$elfList);
#   return $newElf;
# }
# 
# sub steal {
#   my ($elfList, $elfPtr, $step) = @_;
#   my $elfPtr2 = findNextElf($elfList, $elfPtr, $step);
#   # Remove elf2
#   splice(@$elfList, $elfPtr2, 1);
#   $elfPtr-- if $elfPtr2 < $elfPtr;
#   return $elfPtr;
# }

sub buildElfList {
  my $root = buildTree(1, $_[0]);
  my $elfOne = $root;
  while($elfOne->{elf} != 1) {
    $elfOne = $elfOne->{right};
  }
  return ($root, $elfOne);
}

sub buildTree {
  my $mid = int(($_[0] + $_[1]) / 2);
  my $node = { elf => $mid };

  if($mid > $_[0]) {
    $node->{right} = buildTree($_[0], $mid - 1);
    $node->{right}->{parent} = $node;
  } else {
    $node->{right} = { size => 0 };
  }

  if($mid < $_[1]) {
    $node->{left} = buildTree($mid + 1, $_[1]);
    $node->{left}->{parent} = $node;
    $node->{left}->{isLeft} = 1;
  } else {
    $node->{left} = { size => 0 };
  }

  $node->{size} = $_[1] - $_[0] + 1;

  return $node;
}

sub elfListLen {
  return $_[0]->{size};
}

sub removeElf {
  my $node = $_[0];
  $node->{elf} = 0;

  # Decrement size in this and all parent nodes.
  while(defined $node) {
    $node->{size}--;
    $node = $node->{parent};
  }
}

sub findNextElf {
  my ($dummy, $node, $step) = @_;
  return findIdxInTree($node, $step + $node->{right}->{size});
}

sub findIdxInTree {
  my ($node, $idx) = @_;

  if($idx >= $node->{size}) {
    # The index is not within this tree. If this is not the parent node,
    # then move to the parent; otherwise do a modulo of the size.
    if($node->{parent}) {
      if(!($node->{isLeft})) {
        # If this was the right tree, then we need to search the parent.
        return findIdxInTree($node->{parent}, $idx);
      } else {
        # If this was the left tree, then we'll actually be skipping over
        # the entire parent (going to its parent.) We need to add the size
        # of the parent, minus the size of this tree, to the index.
        return findIdxInTree($node->{parent}, 
                             $idx +
                               $node->{parent}->{size} -
                               $node->{size});
      }
    } else {
      $idx %= $node->{size};
    }
  }

  if($idx < $node->{right}->{size}) {
    return findIdxInTree($node->{right}, $idx);
  } else {
    $idx -= $node->{right}->{size};

    # Check whether this node is the one we're trying to find.
    return $node if $idx == 0 && $node->{elf};
    $idx-- if $node->{elf};

    return findIdxInTree($node->{left}, $idx);
  }
}

sub steal {
  my ($dummy, $node, $step) = @_;
  $node = findNextElf($dummy, $node, $step);
  removeElf($node);
}
