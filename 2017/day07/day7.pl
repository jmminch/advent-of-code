# Read in the tree node definitions.
while(<>) {
  if(/(\w+) \((\d+)\)/) {
    my $name = $1;
    my $node = { weight => $2 };
    if(/-> ([a-z, ]+)/) {
      $node->{children} = [ split /, /, $1 ];
    }
    $tree{$name} = $node;
  }
}

# find the root node; it is the one that is not referenced as a child of any
# other node.
my $root;
for my $name (keys %tree) {
  my $found = 0;
  LOOP: for my $name2 (keys %tree) {
    next if $name eq $name2;
    next if not exists $tree{$name2}->{children};
    for my $name3 (@{$tree{$name2}->{children}}) {
      if($name eq $name3) {
        $found = 1;
        last LOOP;
      }
    }
  }

  if(!$found) {
    $root = $name;
    last;
  }
}

# See notes. We are going to look for a node that is not fully balanced, but all
# of its child nodes are.

NODE: for my $node (keys %tree) {
  if(!fully_balanced($node)) {
    # note that a leaf node (no children) is balanced, so the node must have
    # children at this point. Check that all children are balanced.
    for my $child (@{$tree{$node}->{children}}) {
      next NODE if !fully_balanced($child);
    }

    # This is the node we're looking for.
    # Use trial and error to determine which child needs to be modified.
    for(my $i = 0; $i < scalar @{$tree{$node}->{children}}; $i++) {
      # modify the weight of children[$i]
      my $idx2 = $i ? 0 : 1;  # compare with either children[0] or children[1]
      my $dw = weight($tree{$node}->{children}->[$idx2]) -
               weight($tree{$node}->{children}->[$i]);
      $tree{$tree{$node}->{children}->[$i]}->{weight} += $dw;
      
      # check if the tree is now fully balanced.
      if(fully_balanced($root)) {
        # success!
        $part2 = $tree{$tree{$node}->{children}->[$i]}->{weight};
        last NODE;
      } else {
        # return the weight to its original value.
        $tree{$tree{$node}->{children}->[$i]}->{weight} -= $dw;
      }
    }

    # Should never get here; a change to fully balance the tree should
    # have been found in the loop above.
    print "Logic error!\n";
    exit 1;
  }
}

print "Part 1 result: $root\n";
print "Part 2 result: $part2\n";

sub weight {
  #return $tree{$_[0]}->{tot} if exists $tree{$_[0]}->{tot};
  my $total = $tree{$_[0]}->{weight};
  if(exists $tree{$_[0]}->{children}) {
    for my $child (@{$tree{$_[0]}->{children}}) {
      $total += weight($child);
    }
  }
  return $total;
}

# This returns true if this node and all descendent nodes are correctly
# balanced.
sub fully_balanced {
  # cached value
  #return $tree{$_[0]}->{fully_balanced} if exists $tree{$_[0]}->{fully_balanced};

  # leaf nodes are considered fully balanced.
  return 1 if not exists $tree{$_[0]}->{children};

  # check that children are themselves balanced
  for my $child (@{$tree{$_[0]}->{children}}) {
    return 0 if !fully_balanced($child);
  }
  
  # check that the weights of all children match.
  my $w0 = weight($tree{$_[0]}->{children}->[0]);

  for my $child (@{$tree{$_[0]}->{children}}) {
    return 0 if $w0 != weight($child);
  }

  return 1;
}
