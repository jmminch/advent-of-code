use strict vars;

my $part1 = 0;
my $part2 = 0;

while(<>) {
  my $inpLine = [ (substr $_, 0, index($_, ' ')), [ ] ];
  push @{$inpLine->[1]}, $& while /\d+/g;
  $part1 += countPoss(@$inpLine);

  # modify the data according to part 2 rules
  $inpLine->[0] = ($inpLine->[0] . '?') x 5;
  # get rid of trailing '?'
  substr($inpLine->[0], -1, 1) = '';
  $inpLine->[1] = [ ( @{$inpLine->[1]} ) x 5 ];

  $part2 += countPoss(@$inpLine);
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

# Create a new copy of the input data and modify according to the part 2
# rules.
my @input2;
for my $inpLine (@input2) {
  push @input2, [ ($inpLine->[0] . '?') x 5, [ @{$inpLine->[1]} x 5 ] ];
  # get rid of the trailing '?'
  substr($input2[-1]->[0], -1, 1) = '';
}

sub countPoss {
  my ($str, $groups) = @_;
  my @vals = map { ($_ eq '.') ? 1 : ($_ eq '#' ? 2 : 3) }
      split(//, $str);

  my @guesses;
  my $gp = 0; # pointer into the @guesses array

  my $count = 0;

  # Array elements in @guesses start at 0; 1 corresponds to '.', and 2
  # corresponds to '#'. If a contradiction is found or both 1 and 2 have
  # already been tried, then decrement $gp to back up and try different
  # guesses.
  
  # When $gp drops below 0, all combinations have been tried.
  while($gp >= 0) {

    if($gp == scalar @vals) {
      # End of string, check whether it matches groups
      $count++ if(matchGroups(\@guesses, $groups, $gp, 1));
      $gp--;
      next;
    } else {
      # See if the current guesses could possibly be a solution, and back up
      # if not.
      if(!matchGroups(\@guesses, $groups, $gp, 0)) {
        $gp--;
        next;
      }
    }

    $guesses[$gp]++;

    # Back up if we've already tried both guesses in this slot.
    if($guesses[$gp] > 2) { $gp--; next; }

    # Go back around if this guess doesn't match a known value
    if($guesses[$gp] == 1 && $vals[$gp] == 2) { next; }
    if($guesses[$gp] == 2 && $vals[$gp] == 1) { next; }

    # Move to the next cell. Set it to '0' for the initial guess
    $gp++;
    $guesses[$gp] = 0;
  }

  return $count;
}

sub matchGroups {
  my ($guesses, $groups, $guessLen, $end) = @_;

  my $groupIdx = 0; # index of current group
  my $group = 0; # number of defects in group
  for my $i (0..($guessLen - 1)) {
    if($guesses->[$i] == 1 && $group > 0) {
      # End a group if there was one.
      return 0 if $groups->[$groupIdx] != $group;
      $group = 0;
      $groupIdx++;
    } elsif($guesses->[$i] == 2) {
      # Add this to the current group
      $group++;
    }
  }

  if(!$end) {
    # Partial group matching mode. If there is an unclosed group, just check
    # that the group value is at least as large as the current group.
    return 0 if $groups->[$groupIdx] < $group;
    return 1;
  }

  # Full matching mode. Last group size needs to match, and we need to have
  # used all the groups.
  if($group > 0) {
    return 0 if $groups->[$groupIdx] != $group;
    $groupIdx++;
  }

  # make sure all groups were used.
  return 0 if $groupIdx < scalar @$groups;

  return 1;
}
