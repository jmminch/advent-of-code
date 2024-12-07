use strict vars;

our @dirs = ( -1, 1, -65536, 65536 );
our %slopes = ( '>'=>1, '<'=>-1, '^'=>-65536, 'v'=>65536 );

# Read the input map
our @map = <>;
chomp @map;
my $sx = index($map[0], '.'); # find the '.' in the first row as the starting point
@map = map { [ split // ] } @map;

# I need to keep an ordered stack of values for the path, but also to be
# able to determine quickly if a particular element is already in the path.
# So the path structure has a hash for lookups and a list for ordering.
# There are modules for ordered hashes which would probably work as well.
my $path = { lookup=>{ }, order=>[ ] };

our $part1;
our $slopes = 1;  # used to select between part 1 and part 2 logic

findPath($path, mkCoord($sx, 0));

print "Part 1 result: $part1\n";

$slopes = 0;
$part1 = 0;

findPath($path, mkCoord($sx, 0));

print "Part 2 result: $part1\n";

sub mkCoord {
  return ($_[0] + 0x8000) | (($_[1] + 0x8000) << 16)
}

sub decCoord {
  return (($_[0] & 0xffff) - 0x8000, ($_[0] >> 16) - 0x8000);
}

sub pathAdd {
  $_[0]->{lookup}->{$_[1]} = 1;
  push @{$_[0]->{order}}, $_[1];
}

sub pathPop {
  my $r = pop @{$_[0]->{order}};
  delete $_[0]->{lookup}->{$r};
  return $r;
}

sub findPath {
  my ($path, $nextPt) = @_;
  my ($x, $y) = decCoord($nextPt);
  my @nextDirs;

  pathAdd($path, $nextPt);

  if($y == $#map) {
    # ending point
    reportPath($path);
    pathPop($path);
    return;
  }

  # Look for all possible steps from here.
  # If the $slopes variable is not set, then slope tiles are treated the
  # same as any other.
  if($slopes && exists($slopes{$map[$y]->[$x]})) {
    # This is a slope, only try in the slope direction
    $nextDirs[0] = $slopes{$map[$y]->[$x]};
  } else {
    @nextDirs = @dirs;
  }

  for my $dir (@nextDirs) {
    my $pt = $nextPt + $dir;
    next if exists $path->{lookup}->{$pt};
    my ($nx, $ny) = decCoord($pt);
    next if $map[$ny]->[$nx] eq '#';
    # This square is ok.
    findPath($path, $pt);
  }

  pathPop($path);
}

sub reportPath {
  my $path = $_[0];
  my $pathLen = scalar(@{$path->{order}}) - 1;
  if($pathLen > $part1) {
    $part1 = $pathLen;
    print "Found path, len = $part1\n";
  }
}

