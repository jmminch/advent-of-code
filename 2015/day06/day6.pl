use Bit::Vector;

# Create a 1000x1000 map.
my @map = Bit::Vector->new(1000, 1000);

while(<>) {
  if(/ (\d+),(\d+).* (\d+),(\d+)/) {
    # normalize the coordinates.
    my ($x0, $x1) = sort { $a <=> $b } ($1, $3);
    my ($y0, $y1) = sort { $a <=> $b } ($2, $4);

    if(/turn on/) {
      for my $y ($y0..$y1) {
        $map[$y]->Interval_Fill($x0, $x1);
      }
    } elsif(/turn off/) {
      for my $y ($y0..$y1) {
        $map[$y]->Interval_Empty($x0, $x1);
      }
    } elsif(/toggle/) {
      for my $y ($y0..$y1) {
        $map[$y]->Interval_Flip($x0, $x1);
      }
    }
  }
}

my $total = 0;
# number of bits set for each hex digit
my @bitcounts = ( 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4 );
for my $v (@map) {
  my $hex = $v->to_Hex();
  for my $i (0..(length($hex) - 1)) {
    $c = substr($hex, $i, 1);
    $total += $bitcounts[hex(substr($hex, $i, 1))];
  }
}

print "part 1 result: $total\n";
