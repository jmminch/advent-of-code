use strict vars;

# Create the map from the input
my %map;
my %dirs = ( U=>[0,-1], D=>[0,1], L=>[-1,0], R=>[1,0] );
my $x = 0;
my $y = 0;
my $minX = 9e100;
my $maxX = -9e100;
my $minY = 9e100;
my $maxY = -9e100;
while(<>) {
  my ($dir, $len, $color) = split / /;
  next if !defined $color;
  for my $i (1..$len) {
    $x += $dirs{$dir}->[0];
    $y += $dirs{$dir}->[1];
    $map{"$x,$y"} = 1;
  }

  # Keep track of the bounding box
  $minX = $x if $x < $minX;
  $maxX = $x if $x > $maxX;
  $minY = $y if $y < $minY;
  $maxY = $y if $y > $maxY;
}

# Fill the outside of the loop with value 2
my @queue = [ $minX - 1, $minY - 1 ];
while(my $c = shift @queue) {
  my($x, $y) = @$c;
  next if exists $map{"$x,$y"};
  $map{"$x,$y"} = 2;
  for my $dir (values %dirs) {
    my $nx = $x + $dir->[0];
    my $ny = $y + $dir->[1];
    next if $nx < $minX - 1 || $ny < $minY - 1 ||
            $nx > $maxX + 1 || $ny > $maxY + 1;
    push @queue, [$nx,$ny];
  }
}

# Fill anything left with value 3
for my $x ($minX..$maxX) {
  for my $y ($minY..$maxY) {
    $map{"$x,$y"} = 3 if !exists $map{"$x,$y"};
  }
}

# Count all coordinates with value 1 or 3.
my $part1 = 0;
for my $x ($minX..$maxX) {
  for my $y ($minY..$maxY) {
    my $v = $map{"$x,$y"};
    $part1++ if $v == 1 || $v == 3;
  }
}

print "Part 1 result: $part1\n";
