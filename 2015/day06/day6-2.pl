use List::Util qw(reduce);

# Create a 1000x1000 map.
my @map = map { [ (0) x 1000 ] } (1..1000);

while(<>) {
  if(/ (\d+),(\d+).* (\d+),(\d+)/) {
    # normalize the coordinates.
    my ($x0, $x1) = sort { $a <=> $b } ($1, $3);
    my ($y0, $y1) = sort { $a <=> $b } ($2, $4);

    if(/turn on/) {
      for my $y ($y0..$y1) {
        for my $x ($x0..$x1) {
          $map[$y]->[$x]++;
        }
      }
    } elsif(/turn off/) {
      for my $y ($y0..$y1) {
        for my $x ($x0..$x1) {
          $map[$y]->[$x]-- if $map[$y]->[$x] > 0;
        }
      }
    } elsif(/toggle/) {
      for my $y ($y0..$y1) {
        for my $x ($x0..$x1) {
          $map[$y]->[$x] += 2;
        }
      }
    }
  }
}

# sum of all cells
my $total = 0;
for my $y (0..$#map) {
  # add sum of this line
  $total += reduce { $a + $b } @{$map[$y]};
}

print "part 2 result: $total\n";
