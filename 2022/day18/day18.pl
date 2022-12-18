use Data::Dumper;

# read locations of all cubes
while(<>) {
  chomp $_;
  $cube{$_} = 1 if $_ =~ /\d/;
}

my $total = 0;

my @dirs = ( [-1,0,0], [1,0,0], [0,-1,0], [0,1,0], [0,0,-1], [0,0,1] );

# loop through all cubes
for my $c (keys %cube) {

  # find the six adjacent spaces and count how many of those are empty;
  # those are the exposed faces.
  for my $d (@dirs) {
    my @coord = split /,/, $c;
    for my $i (0..$#coord) { $coord[$i] += $d->[$i]; }
    $total++ if not exists $cube{join ',', @coord};
  }
}

print "part 1 result: $total\n";

# part 2. Fill the exterior to determine what cells are exposed.
# First, find the minimum and maximum values for each coordinate.
my @extremes = ( [ 99999, -99999 ], [ 99999, -99999 ], [ 99999, -99999 ] );

for my $c (keys %cube) {
  my @coord = split /,/, $c;
  for my $i (0..2) {
    $extremes[$i]->[0] = $coord[$i] if $coord[$i] < $extremes[$i]->[0];
    $extremes[$i]->[1] = $coord[$i] if $coord[$i] > $extremes[$i]->[1];
  }
}

# grow the border so there's room on all sides around the shape.
for my $i (0..2) {
  $extremes[$i]->[0]--;
  $extremes[$i]->[1]++;
}

# do a flood-fill starting at the corner.

# this is a queue of cells to fill.
my @loc = ( [ $extremes[0]->[0], $extremes[1]->[0], $extremes[2]->[0] ] );

while(scalar @loc > 0) {

  my $loc = shift @loc;

  DIR: for my $d (@dirs) {
    $new = [ @$loc ];
    for my $i (0..2) {
      $new->[$i] += $d->[$i];
      next DIR if $new->[$i] < $extremes[$i]->[0];
      next DIR if $new->[$i] > $extremes[$i]->[1];
    }

    next DIR if exists $cube{join ',', @$new};
    $cube{join ',', @$new} = 2;
    push @loc, $new;
  }
}

# done. Now go through the area and change unmarked cubes to rock; and
# delete exterior filled cubes.

for $i ($extremes[0]->[0]..$extremes[0]->[1]) {
  for $j ($extremes[1]->[0]..$extremes[1]->[1]) {
    for $k ($extremes[2]->[0]..$extremes[2]->[1]) {
      if(!exists $cube{"$i,$j,$k"}) {
        $cube{"$i,$j,$k"} = 1;
      } elsif($cube{"$i,$j,$k"} == 2) {
        delete $cube{"$i,$j,$k"};
      }
    }
  }
}

# now all unreachable spaces are filled with rock. Repeat the same
# calculation from part 1.

# loop through all cubes
$total = 0;
for my $c (keys %cube) {

  # find the six adjacent spaces and count how many of those are empty;
  # those are the exposed faces.
  for my $d (@dirs) {
    my @coord = split /,/, $c;
    for my $i (0..$#coord) { $coord[$i] += $d->[$i]; }
    $total++ if not exists $cube{join ',', @coord};
  }
}

print "part 2 result: $total\n";
