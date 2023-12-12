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

  # The elements of @state are associated with each group in the groups
  # array. Each element is an array of
  # [first possible location,
  #  last possible location,
  #  current guess offset,
  #  starting offset]
  # where current guess offset is 0 for the first possible location.
  # Initially guess is set to -1, which indicates that we need to determine
  # the possible locations.
  my @state = ( [ 0, 0, -1, 0 ] );
  my $sp = 0; # pointer into the @state array

  my $count = 0;

  # When $sp drops below 0, all possibilities have been tried.
  LOOP: while($sp >= 0) {

    if($sp == scalar @$groups) {
      # Reached the end of the groups list. Make sure there there are no
      # more '#' characters after this point (which would necessitate
      # another group.)
      if(index($str, '#', $state[$sp]->[3]) != -1) {
        $sp--;
        next;
      } else {
        # This is a valid combination. Count it and then back up.
        $count++;
        $sp--;
        next;
      }
    }

    if($state[$sp]->[2] == -1) {
      # Find the possible locations for this group, starting at $loc
      # The  first possible location is the offset of the first following
      # '?' or '#' character. The last is the first following '#' character,
      # or the length of the string minus the length of the group; whichever
      # is smaller.
      my $nextQ = index $str, '?', $state[$sp]->[3];
      my $nextH = index $str, '#', $state[$sp]->[3];
      $nextQ = 999999 if $nextQ == -1;
      $nextH = 999999 if $nextH == -1;
      my $first = ($nextQ < $nextH) ? $nextQ : $nextH;
      my $last = length($str) - $groups->[$sp];
      $last = $nextH if $nextH < $last;

      if($first == 999999 || $first > $last) {
        # No possible place for this group.
        $sp--;
        next;
      }

      $state[$sp]->[0] = $first;
      $state[$sp]->[1] = $last;
    }

    # Try the next possible location for the current group.
    $state[$sp]->[2]++;

    my $loc = $state[$sp]->[0] + $state[$sp]->[2];
    if($loc > $state[$sp]->[1]) {
      # Run out of possibilities for this group.
      $sp--;
      next;
    }

    # Check whether all characters in range of this group are '#' or '?'.
    for my $i (1..$groups->[$sp]) {
      if(substr($str, $loc + $i - 1, 1) eq '.') {
        # Can't have a known '.' inside the group; skip this guess
        next LOOP;
      }
    }

    # Check that the character after the group is '.' or '?' (not '#')
    next if substr($str, $loc + $groups->[$sp], 1) eq '#';

    # This location is valid for this group. Move on to the next one.
    $state[$sp + 1] = [ 0, 0, -1, $loc + $groups->[$sp] + 1 ];
    $sp++;
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
