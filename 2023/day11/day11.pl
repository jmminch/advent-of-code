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

# Get sorted lists of the rows/columns that contain galaxies
my @filledRows = sort { $a <=> $b } keys %filledRows;
my @filledCols = sort { $a <=> $b } keys %filledCols;

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
    my $yIdx1 = bsearch(\@filledRows, $y1);
    my $yIdx2 = bsearch(\@filledRows, $y2);

    # the number of rows *missing* between y1, y2 is
    # (y2-y1) - (yIdx2-yIdx1)
    $dist += ($y2 - $y1) - ($yIdx2 - $yIdx1);
    $dist2 += 999999 * (($y2 - $y1) - ($yIdx2 - $yIdx1));

    # swap x1/x2 if necessary
    if($x2 < $x1) {
      my $tmp = $x2;
      $x2 = $x1;
      $x1 = $tmp;
    }
    my $xIdx1 = bsearch(\@filledCols, $x1);
    my $xIdx2 = bsearch(\@filledCols, $x2);
    $dist += ($x2 - $x1) - ($xIdx2 - $xIdx1);
    $dist2 += 999999 * (($x2 - $x1) - ($xIdx2 - $xIdx1));

    $totalDist += $dist;
    $totalDist2 += $dist2;
  }
}

print "Part 1 result: $totalDist\n";
print "Part 2 result: $totalDist2\n";

# note that $value must be in @$array
sub bsearch {
  my ($array, $value) = @_;

  my $x0 = 0;
  my $x1 = $#$array;

  while(1) {
    return $x0 if $value == $array->[$x0];
    return $x1 if $value == $array->[$x1];
    my $m = int(($x0 + $x1) / 2);
    return $m if $value == $array->[$m];
    $x0 = $m + 1 if $value > $array->[$m];
    $x1 = $m - 1 if $value < $array->[$m];
  }
}
