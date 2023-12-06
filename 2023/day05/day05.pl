use strict vars;

# Slurp entire input into a string.
my $input;
{ local $/; $input = <>; }

# Get the list of seeds.
my @seeds;
$input =~ /^seeds: (.*)$/m or die "Could not find list of seeds.";
@seeds = split /\s+/, $1;

# Parse all of the maps.
our %maps;
while($input =~ /(\w+)-to-(\w+) map:(.+?)(\n\n|$)/sg) {
  my $source = $1;
  my $map = $3;
  $maps{$source} = { dest => $2, map => [ ] };
  # $3 has all the lines of mappings; go through them one by one.
  while($map =~ /^(\d.+?)$/mg) {
    push @{$maps{$source}->{map}}, [ split(/\s+/, $1) ];
  }
}

# For part 1, find the minimum "location" value for any of the original
# "seed" values.
my $part1 = 9e100;
for my $seed (@seeds) {
  my $loc = convert("seed", $seed, "location");
  $part1 = $loc if $loc < $part1;
}

print "Part 1 result: $part1\n";

# Part 2 is the same, but the "seed" values define ranges in the form of
# <starting seed #> <number of seeds> <starting seed> <number of seeds> ...
my $part2 = 9e100;
while(my $startSeed = shift @seeds) {
  my $numSeeds = shift @seeds;
  for my $seed ($startSeed..($startSeed + $numSeeds - 1)) {
    my $loc = convert("seed", $seed, "location");
    $part2 = $loc if $loc < $part2;
  }
}

print "Part 2 result: $part2\n";

sub convert {
  my ($source, $id, $target) = @_;

  while($source ne $target) {
    if(not exists $maps{$source}) {
      print "$source\n";
      die;
    }
    $id = applyMap($maps{$source}->{map}, $id);
    $source = $maps{$source}->{dest};
  }

  return $id;
}

sub applyMap {
  my ($map, $id) = @_;

  # Look for a range containing this id.
  for my $mapLine (@$map) {
    if($id >= $mapLine->[1] && $id < $mapLine->[1] + $mapLine->[2]) {
      return $id - $mapLine->[1] + $mapLine->[0];
    }
  }

  # No ranges contain this id; in this case the target id is same as the
  # source.
  return $id;
}
