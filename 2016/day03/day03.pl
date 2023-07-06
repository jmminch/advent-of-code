my $part1 = 0;
my $part2 = 0;
my @lines;
while(my $line = <>) {
  next if not $line =~ /(\d+)\s+(\d+)\s+(\d+)/;
  push @lines, [ $1, $2, $3 ];
  if($#lines > 1) {
    for my $i (0..2) {
      $part1++ if valid(@{$lines[$i]});
      $part2++ if valid($lines[0]->[$i], $lines[1]->[$i], $lines[2]->[$i]);
    }
    @lines = ();
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub valid {
  return 1 if $_[0] < $_[1] + $_[2] &&
              $_[1] < $_[0] + $_[2] &&
              $_[2] < $_[0] + $_[1];
  return 0;
}
