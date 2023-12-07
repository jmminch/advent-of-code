use strict vars;
use Data::Dumper;

my @points;
while(<>) {
  push @points, [ $1, $2, $3, $4 ] 
    if /([\d\-]+).+?([\d\-]+).+?([\d\-]+).+?([\d\-]+)/;
}

my $lastSize = bboxSize(\@points);
for(my $t = 1; 1; $t++) {
  my $newPoints = simulate(\@points, $t);
  my $newSize = bboxSize($newPoints);
  if($newSize > $lastSize) {
    # box is growing; display the state from the last second.
    my $points2 = simulate(\@points, $t - 1);
    displayBox($points2);
    printf "\nTime: %d sec\n", $t - 1;
    last;
  }
  $lastSize = $newSize;
}

sub simulate {
  my ($points, $t) = @_;
  my @output;

  for my $pt (@$points) {
    push @output, [ $pt->[0] + $t * $pt->[2],
                    $pt->[1] + $t * $pt->[3] ];
  }

  return \@output;
}

sub bbox {
  my $points = $_[0];
  my $minX = 9e100;
  my $minY = 9e100;
  my $maxX = -9e100;
  my $maxY = -9e100;

  for my $pt (@$points) {
    $minX = $pt->[0] if $pt->[0] < $minX;
    $maxX = $pt->[0] if $pt->[0] > $maxX;
    $minY = $pt->[1] if $pt->[1] < $minY;
    $maxY = $pt->[1] if $pt->[1] > $maxY;
  }

  return ( $minX, $maxX, $minY, $maxY );
}

sub bboxSize {
  my ($minX, $maxX, $minY, $maxY) = bbox($_[0]);
  return $maxX - $minX + $maxY - $minY;
}

sub displayBox {
  my $points = $_[0];
  my %map;
  for my $pt (@$points) {
    $map{$pt->[0] . "," . $pt->[1]} = 1;
  }
  my ($minX, $maxX, $minY, $maxY) = bbox($points);
  for my $y ($minY..$maxY) {
    for my $x ($minX..$maxX) {
      print ((exists $map{"$x,$y"}) ? '#' : ' ');
    }
    print "\n";
  }
}
