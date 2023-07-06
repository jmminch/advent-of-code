our $part2 = 0;
our @chars = split //, <>;

# stream is supposed to be a full group, so must start with '{'.
die if shift(@chars) != '{';
$root = readGroup();

printf "Part 1 result: %d\n", totalScore($root, 1);
print "Part 2 result: $part2\n";

# readGroup will return an array reference containing the group contents.
sub readGroup {
  my $group = [ ];

  while(my $c = shift @chars) {
    return $group if $c eq '}';
    next if $c eq ',';
    push @$group, readGroup() if $c eq '{';
    push @$group, readGarbage() if $c eq '<';
  }

  die "malformed group!";
}

# readGarbage will return a count of the number of non-cancelled characters
# within this garbage.
sub readGarbage {
  my $count = 0;

  while(my $c = shift @chars) {
    if($c eq '>') {
      # part 2 result is the sum of all garbage.
      $part2 += $count;
      return $count;
    }
    if($c eq '!') {
      # skip this char and the next one.
      shift @chars;
      next;
    }
    # otherwise, count this character.
    $count++;
  }
 
  die "malformed garbage!";
}

# Find the "score" for all groups in this tree. The score of any group is
# one more than the score of the containing group.
sub totalScore {
  my ($group, $cscore) = @_;
  my $total = $cscore;
  for $child (@$group) {
    $total += totalScore($child, $cscore + 1) if ref $child eq 'ARRAY';
  }
  return $total;
}
