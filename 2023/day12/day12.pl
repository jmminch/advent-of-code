use strict vars;

# Read input into an array
my @input;
while(<>) {
  push @input, [ (substr $_, 0, index($_, ' ')), [ ] ];
  push @{$input[-1]->[1]}, $& while /\d+/g;
}

my $count = 0;
for my $inpLine (@input) {
  $count += countPoss(@$inpLine);
}

print "Part 1 result: $count\n";

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

  if($group > 0) {
    return 0 if $groups->[$groupIdx] != $group;
    $groupIdx++;
  }

  # make sure all groups were used.
  return 0 if $groupIdx < scalar @$groups;

  return 1;
}
