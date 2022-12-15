# the input is a line of parens; ( means to increment a counter and )
# means to decrement it.
# part 1: find the ending value of the counter
# part 2: find at which character (1 based) the counter first is -1.

my $line = <>;

my @spl = split //, $line;
for $i (0..$#spl) {
  my $c = $spl[$i];
  $counter++ if $c eq '(';
  $counter-- if $c eq ')';

  # looking for the first time $counter hits -1.
  $part2 = ($i + 1) if $counter == -1 && $part2 == 0;
}

print "part 1 result: $counter\n";
print "part 2 result: $part2\n";
