use strict vars;
use Data::Dumper;

my @galaxies;    # Coordinates of all galaxies
my %filledRows;  # All rows that contain at least one galaxy
my %filledCols;  # All columns that contain at least one galaxy

# Read the input and find the coordinates of all galaxies
my $y = 0;
while(<>) {
  my @chars = split //;
  for my $x (0..$#chars) {
    if($chars[$x] eq '#') {
      push @galaxies, [ $y, $x ];
      $filledRows{$y} = 1;
      $filledCols{$x} = 1;
    }
  }
  $y++;
}

# Find the distance between each pair of galaxies
my $totalDist = 0;
my $totalDist2 = 0; # for part 2
for my $i (0..$#galaxies) {
  for my $j (($i+1)..$#galaxies) {
    my ($y1, $x1) = @{$galaxies[$i]};
    my ($y2, $x2) = @{$galaxies[$j]};
    # manhattan distance
    my $dist = abs($y1-$y2) + abs($x1-$x2);
    my $dist2 = $dist;
    # add in the number of rows and cols between the two
    # note y1 is always <= y2 because of the order we read the input
    for my $y (($y1+1)..($y2-1)) {
      if(!exists $filledRows{$y}) {
        $dist++;
        $dist2 += 999999;
      }
    }

    if($x2 < $x1) {
      my $tmp = $x2;
      $x2 = $x1;
      $x1 = $tmp;
    }
    for my $x (($x1+1)..($x2-1)) {
      if(!exists $filledCols{$x}) {
        $dist++;
        $dist2 += 999999;
      }
    }
    $totalDist += $dist;
    $totalDist2 += $dist2;
  }
}

print "Part 1 result: $totalDist\n";
print "Part 2 result: $totalDist2\n";
