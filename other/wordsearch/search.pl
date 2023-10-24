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
  my $grid = { width => $width, height => $height };

  my $result = placeWords($grid, $words, 0);

  printGrid($grid);

  return $result;
}

sub placeWords {
  my ($grid, $words, $wordIdx) = @_;

  return 1 if $wordIdx > $#words;

  # try all possible positions for this word
  for(my $y = 0; $y < $grid->{height}; $y++) {
    for(my $x = 0; $x < $grid->{width}; $x++) {
      for(my $dir = 0; $dir < 8; $dir++) {
        print "$wordIdx $x $y $dir\n" if $wordIdx < 3;
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
  return '.' if !exists $grid->{"$x.$y"};
  return $grid->{"$x.$y"}->[0];
}

# Set the character at x,y; increment its counter
sub setAt {
  my ($grid, $x, $y, $c) = @_;
  $grid->{"$x.$y"} = [ $c, 0 ] if !exists $grid->{"$x.$y"};
  $grid->{"$x.$y"}->[1]++;
}

# Decrement the counter at x,y and delete the entry if the counter is 0
sub delAt {
  my ($grid, $x, $y) = @_;
  $grid->{"$x.$y"}->[1]--;
  delete $grid->{"$x.$y"} if !$grid->{"$x.$y"}->[1];
}

sub placeWord {
  my ($grid, $sx, $sy, $word, $dir) = @_;
  my @dirs = (
    [-1,-1], [-1,0], [-1,1],
    [-1,0],          [1,0],
    [-1,1],  [1,0],  [1,1] );

  # check if the word fits
  for(my $i = 0; $i < length $word; $i++) {
    my $x = $sx + $i * $dirs[$dir]->[0];
    my $y = $sy + $i * $dirs[$dir]->[1];
    return 0 if $x < 0 || $y < 0 || $x >= $grid->{width} || $y >= $grid->{height};
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
  for(my $y = 0; $y < $grid->{height}; $y++) {
    for(my $x = 0; $x < $grid->{width}; $x++) {
      print getAt($grid, $x, $y);
    }
    print "\n";
  }
}
