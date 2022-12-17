# read input. Create a table of rules{person}->{other person} = +/- happiness
while(<>) {
  if(/(\w+) would (gain|lose) (\d+) happiness.*to (\w+)/) {
    # create a table for this person if this is the first time we've seen
    # their name.
    $rules{$1} = {} if not exists $rules{$1};

    $rules{$1}->{$4} = ($2 eq 'gain') ? $3 : -$3;
  }
}

my @people = sort keys %rules;
my $total = -999999; # best total could be negative, so make sure that
                     # this is lower than the worst possible.

permute(\@people, 0);

print "part 1 result: $total\n";

push @people, 'myself';

# don't need to make changes to the rules table since lookups for an entry
# that doesn't exist will just return undef which is equivalent to 0 when
# adding.

$total = -999999;

permute(\@people, 0);

print "part 2 result: $total\n";

# cribbed from day09.pl
sub permute {
  my ($list, $idx) = @_;

  if($idx == $#$list) {
    # last element; calculate total happiness for this configuration.
    my $tot = 0;
    for my $i (0..$#$list) {
      # note that 0 - 1 is OK since perl interprets that as the last
      # element.
      $tot += $rules{$list->[$i]}->{$list->[$i - 1]};

      $tot += $rules{$list->[$i]}->{$list->[($i + 1) % (scalar @$list)]};
    }

    $total = $tot if $tot > $total;

  } else {
    # rotate the last elements of the list, starting at idx, and then call
    # permute on the remaining elements for each rotation until the first
    # element is back in its original place.
    for my $i ($idx..$#$list) {
      # remove the element at $idx and insert at the end to rotate 1 left.
      push @$list, splice(@$list, $idx, 1);

      permute($list, $idx+1);
    }
  }
}
