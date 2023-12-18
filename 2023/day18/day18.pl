use strict vars;

# Map the letters (for part 1) and digits (for part 2) to directions
my %dirMap = ( 3=>[0,-1], 1=>[0,1], 2=>[-1,0], 0=>[1,0] );
my %dirs = ( R=>0, D=>1, L=>2, U=>3 );

# Counters for part 1
my $part1 = 0;
my $x1 = 0;
my $y1 = 0;

# Counters for part 2
my $part2 = 0;
my $x2 = 0;
my $y2 = 0;

while(<>) {
  my ($dir, $len, $color) = split / /;
  next if !defined $color;

  my ($nx, $ny);
  $nx = $x1 + $len * $dirMap{$dirs{$dir}}->[0];
  $ny = $y1 + $len * $dirMap{$dirs{$dir}}->[1];
  $part1 += ($nx + $x1) * ($ny - $y1) / 2;
  $part1 += $len / 2;
  $x1 = $nx;
  $y1 = $ny;

  $color =~ /#(.....)(.)/;
  $dir = $2;
  $len = hex $1;

  $nx = $x2 + $len * $dirMap{$dir}->[0];
  $ny = $y2 + $len * $dirMap{$dir}->[1];
  $part2 += ($nx + $x2) * ($ny - $y2) / 2;
  $part2 += $len / 2;
  $x2 = $nx;
  $y2 = $ny;
}

$part1++;
$part2++;

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
