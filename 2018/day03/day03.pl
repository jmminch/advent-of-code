use strict vars;
use Data::Dumper;

my @defs = <>;
my %map;

# Loop through all definitions and increment the count for each cell inside
# each rectangle.
for my $def (@defs) {
  if($def =~ /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/) {
    my $x0 = $2;
    my $y0 = $3;
    my $x1 = $x0 + $4 - 1;
    my $y1 = $y0 + $5 - 1;

    for my $x ($x0..$x1) {
      for my $y ($y0..$y1) {
        $map{"$x,$y"}++;
      }
    }
  }
}

# Part 1: count the number of cells with a count > 1
my $part1 = 0;
for my $count (values %map) {
  $part1++ if $count > 1;
}
print "Part 1 result: $part1\n";

# Part 2: Find a rectangle where all the counts within its range are 1.
DEF: for my $def (@defs) {
  if($def =~ /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/) {
    my $id = $1;
    my $x0 = $2;
    my $y0 = $3;
    my $x1 = $x0 + $4 - 1;
    my $y1 = $y0 + $5 - 1;

    for my $x ($x0..$x1) {
      for my $y ($y0..$y1) {
        next DEF if $map{"$x,$y"} > 1;
      }
    }

    print "Part 2 result: $id\n";
    last DEF;
  }
}

