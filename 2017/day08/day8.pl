use List::Util qw(max);

my %regs; # register values.
my $part2 = 0;

# loop through all lines
while(<>) {
  if(/(\w+) (\w+) ([-\d]+) if (\w+) (\S+) ([-\d]+)/) {
    # Transform each line into a valid perl statement.
    my $op = ($2 eq 'inc') ? "+=" : "-=";
    my $es = "\$regs{$1} $op $3 if \$regs{$4} $5 $6";
    # and evaluate it.
    eval($es);

    # We need to track the highest register value ever seen.
    my $max = max(values %regs);
    $part2 = $max if $max > $part2;
  }
}

# part 1 is the highest register value at the end.
printf "Part 1 result: %d\n", max(values %regs);
print "Part 2 result: $part2\n";
