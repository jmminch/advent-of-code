use strict vars;
use Data::Dumper;

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
  my $loc = convert("seed", "location", $seed);
  $part1 = $loc if $loc < $part1;
}

print "Part 1 result: $part1\n";

# Part 2 is the same, but the "seed" values define ranges in the form of
# <starting seed #> <number of seeds> <starting seed> <number of seeds> ...
my @ranges;

# loop through all defined ranges
while(my $startSeed = shift @seeds) {
  my $numSeeds = shift @seeds;

  # convert each range to a set of location ranges.
  push @ranges, convert("seed", "location",
                        $startSeed, $startSeed + $numSeeds - 1);
}

# Now find the smallest starting value in @ranges.
my $part2 = 9e100;
for my $range (@ranges) {
  $part2 = $range->[0] if $range->[0] < $part2;
}

print "Part 2 result: $part2\n";

# Convert an input value or range of values into the target category type.
sub convert {
  my ($source, $target, $start, $end) = @_;
  $end = $start if not defined $end;
  my @ranges = ( [ $start, $end ] );

  while($source ne $target) {
    if(not exists $maps{$source}) {
      print "no map $source\n";
      die;
    }

    my @newRanges = ( );
    for my $range (@ranges) {
      push @newRanges, applyMap($maps{$source}->{map},
                                $range->[0], $range->[1]);
    }
    @ranges = @newRanges;
    $source = $maps{$source}->{dest};
  }

  return wantarray ? @ranges : $ranges[0]->[0];
}

# Use a translation map to translate a range of starting input values into
# destination values.
# Input: map, starting value, ending value
# Output: List of [ start, end ] ranges
sub applyMap {
  my ($map, $start, $end) = @_;
  my @result;

  LOOP: while($start <= $end) {
    my $mapLineEnd = 9e100;
    my $rangeDef = [ $start, $start, 9e100 ];

    # Look for a range containing the start id
    for my $mapLine (@$map) {
      if($start >= $mapLine->[1] && $start < $mapLine->[1] + $mapLine->[2]) {
        # Range found.
        $rangeDef = $mapLine;
        last;
      } else {
        # Keep track of the "closest" starting point for another range, in
        # case this start id occurs outside any defined range.
        if($start < $mapLine->[1] &&
           $mapLine->[1] < $mapLineEnd) {
          $mapLineEnd = $mapLine->[1] - 1;
          $rangeDef->[2] = $mapLine->[1] - $start;
        }
      }
    }
      
    # Range found.
    my $rangeEnd = $rangeDef->[1] + $rangeDef->[2] - 1;
    $rangeEnd = ($end < $rangeEnd) ? $end : $rangeEnd;

    # Convert to a range of destination values
    push @result, [ $start - $rangeDef->[1] + $rangeDef->[0],
                    $rangeEnd - $rangeDef->[1] + $rangeDef->[0] ];

    $start = $rangeEnd + 1;
    next LOOP;
  }

  return @result;
}
