use strict vars;
use Data::Dumper;

my $part1 = 0;
my $part2 = 0;

# Read the schematic
our @schema = <>;
chomp @schema;

# Get the character at (y,x). Return '.' (empty) if out of bounds.
sub get {
  return '.' if $_[0] < 0 || $_[1] < 0;
  return '.' if $_[0] > $#schema;
  return '.' if $_[1] >= length($schema[$_[0]]);
  return substr($schema[$_[0]], $_[1], 1);
}

# All adjacent squares.
my @adj = ( [-1,-1], [-1,0], [-1,1], [0,-1], [0,1], [1,-1], [1,0], [1,1] );

my %gearData;

# iterate through the map
for my $y (0..$#schema) {
  for(my $x = 0; $x < length $schema[$y]; $x++) {
    # Look for the first digit in a number
    if(get($y, $x) =~ /\d/) {
      my $val = 0;
      my $foundSymbol = 0;
      my %gearList = ( );

      # Loop until end of number is found.
      do {
        # Add this digit to the end of the current number.
        $val = $val * 10 + get($y, $x);

        # Look to see if this digit is adjacent to a symbol.
        # Since for part 2 I need to find all symbols, I can no longer quit
        # after finding the first one.
        for my $delta (@adj) {
          my $c = get($y + $delta->[0], $x + $delta->[1]);
          # symbol is anything but '.' or a digit.
          if($c ne '.' && !($c =~ /\d/)) {
            $foundSymbol = 1;

            if($c eq '*') {
              # Using a hash so that we only end up with a single instance
              # of each unique gear location.
              $gearList{($y + $delta->[0]) . ',' . ($x + $delta->[1])} = 1;
            }
          }
        }

        $x++;
      } while(get($y, $x) =~ /\d/);

      # All digits for the last number have been processed.
      $part1 += $val if $foundSymbol;

      # Add this value to the gear data for any adjacent gears.
      for my $gearLoc (keys %gearList) {
        push @{$gearData{$gearLoc}}, $val;
      }

      # Note that the current (y,x) does not point to a digit, so it's fine
      # that the next iteration of this loop will do x++
    }
  }
}

print "Part 1 result: $part1\n";

# Process the gear data list.
for my $gear (values %gearData) {
  # Only '*'s with exactly two adjacent numbers are gears.
  next if scalar @{$gear} != 2;
  $part2 += $gear->[0] * $gear->[1];
}

print "Part 2 result: $part2\n";
