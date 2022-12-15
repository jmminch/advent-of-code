# the input is a list of box dimensions; we need the total of the surface
# area of each box + the smallest side of each box.

while(<>) {
  if(/(\d+)x(\d+)x(\d+)/) {
    my $side1 = $1 * $2;
    my $side2 = $1 * $3;
    my $side3 = $2 * $3;
    my $smallest = $side1;
    $smallest = $side2 if $side2 < $smallest;
    $smallest = $side3 if $side3 < $smallest;
    $total += 2 * $side1 + 2 * $side2 + 2 * $side3 + $smallest;

    my $p1 = 2 * $1 + 2 * $2;
    my $p2 = 2 * $1 + 2 * $3;
    my $p3 = 2 * $2 + 2 * $3;
    $smallest = $p1;
    $smallest = $p2 if $p2 < $smallest;
    $smallest = $p3 if $p3 < $smallest;
    $total2 += $smallest + ($1 * $2 * $3);
  }
}

print "part 1 result: $total\n";
print "part 2 result: $total2\n";
