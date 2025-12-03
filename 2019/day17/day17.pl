#!/usr/bin/perl

require "./intcode.pl";

use strict vars;

# Generate the input map from the Intcode program.
my $icInput = <>;
chomp;
my @program = split ',', $icInput;

my $mapString = '';
runIntcode(\@program, undef, sub { $mapString .= chr($_[0]) });

# Read the input map
chomp $mapString;
our @map = split /\n/, $mapString;
chomp @map;
@map = map { [ split // ] } @map;

our @dirs = ( -65536, 1, 65536, -1 );

sub get {
  my $x = $_[0] % 65536;
  my $y = int($_[0] / 65536);
  return '.' if $x < 0 || $y < 0 || $y > $#map || $x > $#{$map[$y]};
  return $map[$y]->[$x];
}

# Find all intersections
my $part1 = 0;
for my $y (0..$#map) {
  for my $x (0..$#{$map[$y]}) {
    my $loc = 65536 * $y + $x;

    next if get($loc) eq '.';

    my $count = 0;
    # Counting as an intersection if it has at least 3 neighbors. I think in
    # reality all intersections have 4.
    for my $d (@dirs) {
      $count++ if get($loc + $d) eq '#';
    }

    $part1 += $x * $y if $count > 2;
  }
}

print "Part 1 result: $part1\n";

# Determine a path that takes the robot to the exit.

# locate the robot's position and direction
my ($rloc, $rd);
LOOP: for my $y (0..$#map) {
  for my $x (0..$#{$map[$y]}) {
    my $loc = 65536 * $y + $x;
    my $c = get($loc);
    next if $c eq '.' || $c eq '#';
    if($c eq '^') {
      $rloc = $loc; $rd = 0; last LOOP;
    } elsif($c eq '>') {
      $rloc = $loc; $rd = 1; last LOOP;
    } elsif($c eq 'v') {
      $rloc = $loc; $rd = 2; last LOOP;
    } elsif($c eq '<') {
      $rloc = $loc; $rd = 3; last LOOP;
    }
  }
}

my @steps = ();

while(1) {
  
  # If there is scaffold in front of the robot, step forward.
  if(get($rloc + $dirs[$rd]) eq '#') {
    push @steps, 'F';
    $rloc += $dirs[$rd];
    
  # Turn right if there is scaffold to the right.
  } elsif(get($rloc + $dirs[($rd + 1) % 4]) eq '#') {
    push @steps, 'R';
    $rd++;
    $rd -= 4 if $rd == 4;

  # Turn left if there is scaffold to the left
  } elsif(get($rloc + $dirs[($rd + 3) % 4]) eq '#') {
    push @steps, 'L';
    $rd--;
    $rd += 4 if $rd == -1;

  } else {
    # only way is back. End of path.
    last;
  }
}

# Now combine all the steps to create the path.
my @path = ();

while(my $s = shift @steps) {
  if($s eq 'R' || $s eq 'L') {
    push @path, $s;
  } elsif($s eq 'F') {
    my $len = 1;
    while($steps[0] eq 'F') {
      $len++;
      shift @steps;
    }
    push @path, $len;
  }
}

# We have the path. Generate a compressed form of the path.
my %state = ( 
  path => \@path,  # path to compress
  ptr => 0,        # current position in path
  cpath => [ ],    # compressed path
  func => [ ],     # movement functions
  complete => 0
); 

compressPath(\%state);

if($state{complete}) {
  print "Part 2 results:\n";
  printf "  main movement: %s\n",
    join(',', map { chr(65 + $_) } @{$state{cpath}});
  printf "  movement function A: %s\n", join(',', @{$state{func}->[0]});
  printf "  movement function B: %s\n", join(',', @{$state{func}->[1]});
  printf "  movement function C: %s\n", join(',', @{$state{func}->[2]});
}

# Reinitialize the Intcode program
@program = split ',', $icInput;

# Set part 2 mode
$program[0] = 2;

# Create a string containing the input data to the program.
my $input = join(',', map { chr(65 + $_) } @{$state{cpath}});
$input .= "\n";
$input .= join(',', @{$state{func}->[0]});
$input .= "\n";
$input .= join(',', @{$state{func}->[1]});
$input .= "\n";
$input .= join(',', @{$state{func}->[2]});
$input .= "\n";
$input .= "n\n";

my @inputChars = split //, $input;
my $part2 = 0;
# Run the Intcode program, providing the characters one at a time as input,
runIntcode(\@program, 
  sub { ord(shift @inputChars) },
  sub { $part2 = $_[0] } );

print "Part 2 result: $part2\n";

sub compressPath {
  my $state = $_[0];

  # Check whether the compressed path is too long (more than 10 terms, since
  # the max is 20 characters.)
  if(scalar @{$state->{cpath}} > 10) {
    return 0;
  }

  if($state->{ptr} > $#{$state->{path}}) {
    # End of path.
    $state->{complete} = 1;
    return 1;
  }

  # Try to match any existing movement functions.
  # Loop through existing functions
  for my $i (0..$#{$state->{func}}) {
    my $match = 1;

    # Loop through each step of function
    for my $j (0..$#{$state->{func}->[$i]}) {
      if($state->{path}->[$state->{ptr} + $j] !=
         $state->{func}->[$i]->[$j]) {
        $match = 0;
        last;
      }
    }

    if($match) {
      # This is a match!
      push @{$state->{cpath}}, $i;
      $state->{ptr} += scalar @{$state->{func}->[$i]};
      if(compressPath($state)) {
        return 1;
      }
      pop @{$state->{cpath}};
      $state->{ptr} -= scalar @{$state->{func}->[$i]};
    }
  }

  # Will need a new function. Make sure that we're not at the limit.
  if(scalar(@{$state->{func}}) == 3) {
    return 0;
  }

  # Try creating a new function; start with the longest possible and then
  # repeatedly shorten it.
  push @{$state->{func}}, [ ];
  my $funcIdx = $#{$state->{func}};
  my $func = $state->{func}->[$funcIdx];

  # Add terms to func until either the path is exhausted or reaching the
  # function size limit.
  for my $i ($state->{ptr}..$#{$state->{path}}) {
    push @$func, $state->{path}->[$i];
    if(calcFuncLen($func) > 20) {
      pop @$func;
      last;
    }
  }

  # Add a call to this function to the end of the compressed path and
  # increment the pointer.
  push @{$state->{cpath}}, $funcIdx;
  $state->{ptr} += scalar @$func;

  while(scalar(@$func) > 0) {
    # Try this function.
    if(compressPath($state)) {
      return 1;
    }

    # Doesn't work; shorten the function.
    pop @$func;
    $state->{ptr}--;
  }

  # Cannot start a function from this point. Return the state to what it
  # was. The ptr field should already be reset.
  pop @{$state->{cpath}};
  pop @{$state->{func}};

  return 0;
}

# Calculate the size, in characters, of the given function.
sub calcFuncLen {
  return length (join ',', @{$_[0]});
}
