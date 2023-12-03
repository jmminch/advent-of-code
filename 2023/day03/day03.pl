use strict vars;

my $part1 = 0;

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

# iterate through the map
for my $y (0..$#schema) {
  for(my $x = 0; $x < length $schema[$y]; $x++) {
    # Look for the first digit in a number
    if(get($y, $x) =~ /\d/) {
      my $val = 0;
      my $foundSymbol = 0;

      # Loop until end of number is found.
      do {
        # Add this digit to the end of the current number.
        $val = $val * 10 + get($y, $x);

        # Look to see if this digit is adjacent to a symbol.
        if(!$foundSymbol) {
          for my $delta (@adj) {
            my $c = get($y + $delta->[0], $x + $delta->[1]);
            # symbol is anything but '.' or a digit.
            if($c ne '.' && !($c =~ /\d/)) {
              $foundSymbol = 1;
              last;
            }
          }
        }

        $x++;
      } while(get($y, $x) =~ /\d/);

      # All digits for the last number have been processed.
      $part1 += $val if $foundSymbol;

      # Note that the current (y,x) does not point to a digit, so it's fine
      # that the next iteration of this loop will do x++
    }
  }
}

print "Part 1 result: $part1\n";
