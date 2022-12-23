use Data::Dumper;

while(<>) {
  if(/(-?\d+)/) {
    push @values, $1;
    push @refs, \$values[-1];
  }
}

# make a copy of the data to use in part 2.
my @values2 = @values;

mix();

# now figure out where the value '0' lives.
my $idx;
for($idx = 0; $idx <= $#values; $idx++) {
  last if !$values[$idx];
}

my $part1 = ($values[($idx + 1000) % (scalar @values)] + 
             $values[($idx + 2000) % (scalar @values)] +
             $values[($idx + 3000) % (scalar @values)]);

print "part 1 result: $part1\n";

# FIXME (or not)
# Part 2 doesn't work for my input data. Since I wrote day20.c which does
# work, I'm not bothering to debug this further at the moment.

# Restore the original data for part 2.
@values = @values2;

# For part 2, all values must be multiplied by a magic number, 811589153.
for my $idx (0..$#values) {
  $values[$idx] *= 811589153;
  $refs[$idx] = \$values[$idx];
}

# now mix 10 times.
for my $i (1..10) {
  mix();
}

# now figure out where the value '0' lives.
for($idx = 0; $idx <= $#values; $idx++) {
  last if !$values[$idx];
}

my $part2 = ($values[($idx + 1000) % (scalar @values)] + 
             $values[($idx + 2000) % (scalar @values)] +
             $values[($idx + 3000) % (scalar @values)]);

print "part 2 result: $part2\n";



sub mix {
  my $rotMod = (scalar @values) - 1;

  for my $r (@refs) {
    # Find the current offset of this element in the array @values.
    my $idx;
    for($idx = 0; $idx <= $#values; $idx++) {
      last if $r == \$values[$idx];
    }

    # Find how far to shift this element.
    my $rot = $$r;
    $rot %= $rotMod;

    next if $rot == 0; # no need to move
    splice @values, $idx, 1;
    splice @values, ($idx + $rot) % $rotMod, 0, $$r;
  }
}
