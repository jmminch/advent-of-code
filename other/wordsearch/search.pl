use Data::Dumper;

# read the word list, convert to uppercase, remove non-letters
while(<>) {
  $_ = uc $_;
  s/[^A-Z]//g;
  push @words, $_;
}

# Sort in reverse order of length
@words = sort { length($b) <=> length($a) } @words;

my $result = genGrid(9, 9, \@words);

print "Result: $result\n";

sub genGrid {
  my ($width, $height, $words) = @_;
  
  # Grid structure:
  # elem 0: width
  # elem 1: height
  # elem 2: array containing characters
  # elem 3: array containing counts
  my $grid = [ $width, $height, [ ], [ ] ];

  my $result = placeWords($grid, $words, 0);

  printGrid($grid);

  return $result;
}

sub placeWords {
  my ($grid, $words, $wordIdx) = @_;

  return 1 if $wordIdx > $#words;

  # try all possible positions for this word
  for(my $y = 0; $y < $grid->[0]; $y++) {
    for(my $x = 0; $x < $grid->[1]; $x++) {
      for(my $dir = 0; $dir < 8; $dir++) {
        if(placeWord($grid, $x, $y, $words[$wordIdx], $dir)) {
          return 1 if placeWords($grid, $words, $wordIdx + 1);
          delWord($grid, $x, $y, $words[$wordIdx], $dir);
        }
      }
    }
  }

  return 0;
}

# Get the character at x,y; '.' if nothing
sub getAt {
  my ($grid, $x, $y) = @_;
  my $elem = $y * $grid->[0] + $x;
  return '.' if $grid->[3]->[$elem] < 1;
  return $grid->[2]->[$elem];
}

# Set the character at x,y; increment its counter
sub setAt {
  my ($grid, $x, $y, $c) = @_;
  my $elem = $y * $grid->[0] + $x;
  $grid->[2]->[$elem] = $c;
  $grid->[3]->[$elem]++;
}

# Decrement the counter at x,y
sub delAt {
  my ($grid, $x, $y) = @_;
  my $elem = $y * $grid->[0] + $x;
  $grid->[3]->[$elem]--;
}

sub placeWord {
  $counter++;
  die if $counter > 1000000;
  my ($grid, $sx, $sy, $word, $dir) = @_;
  my @dirs = (
    [-1,-1], [-1,0], [-1,1],
    [-1,0],          [1,0],
    [-1,1],  [1,0],  [1,1] );

  # check if the word fits
  for(my $i = 0; $i < length $word; $i++) {
    my $x = $sx + $i * $dirs[$dir]->[0];
    my $y = $sy + $i * $dirs[$dir]->[1];
    return 0 if $x < 0 || $y < 0 || $x >= $grid->[0] || $y >= $grid->[1];
    my $c = getAt($grid, $x, $y);
    return 0 if $c ne '.' && $c ne substr($word, $i, 1);
  }

  # place the word
  for(my $i = 0; $i < length $word; $i++) {
    my $x = $sx + $i * $dirs[$dir]->[0];
    my $y = $sy + $i * $dirs[$dir]->[1];
    setAt($grid, $x, $y, substr($word, $i, 1));
  }
  return 1;
}

sub delWord {
  my ($grid, $sx, $sy, $word, $dir) = @_;
  my @dirs = (
    [-1,-1], [-1,0], [-1,1],
    [-1,0],          [1,0],
    [-1,1],  [1,0],  [1,1] );
  # remove the word
  for(my $i = 0; $i < length $word; $i++) {
    my $x = $sx + $i * $dirs[$dir]->[0];
    my $y = $sy + $i * $dirs[$dir]->[1];
    delAt($grid, $x, $y);
  }
}

sub printGrid {
  my $grid = $_[0];
  for(my $y = 0; $y < $grid->[0]; $y++) {
    for(my $x = 0; $x < $grid->[1]; $x++) {
      print getAt($grid, $x, $y);
    }
    print "\n";
  }
}
