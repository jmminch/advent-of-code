use strict vars;

my @deltas = <>;
chomp @deltas;

# Apply the list once
my $part1 = 0;
for my $d (@deltas) {
  $part1 += $1 if $d =~ /\+(\d+)/;
  $part1 -= $1 if $d =~ /\-(\d+)/;
}

my %found; # track which values have been used so far
my $part2 = 0;
my $ptr = 0;
# Keep looping until a duplicate value is found
while(not exists $found{$part2}) {
  $found{$part2} = 1;
  my $d = $deltas[$ptr];
  $part2 += $1 if $d =~ /\+(\d+)/;
  $part2 -= $1 if $d =~ /\-(\d+)/;

  # keep looping through the list
  $ptr++;
  $ptr = 0 if $ptr > $#deltas;
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
