use strict vars;
use Data::Dumper;
use Scalar::Util qw(refaddr);

our $FLOOR = 0; # used as a reference
our @bricks;
our %map;
while(<>) {
  push @bricks, makeBrick($_);
  mapBrick($bricks[-1]);
}

dropAllBricks();

my $part1 = 0;
for my $brick (@bricks) {
  $part1++ if canSafeRemove($brick);
}
print "Part 1 result: $part1\n";

# Make a list of everything supporting each brick.
my @supports = ( );
for my $brick (@bricks) {
  push @supports, [ supporting($brick) ];
}

my $part2 = 0;
for my $brick (@bricks) {
  my %removed = ( refaddr($brick) => 1 );
  my $changed;
  do {
    $changed = 0;
    for my $i (0..$#bricks) {
      next if exists $removed{refaddr($bricks[$i])};
      my $count = 0;
      for my $support (@{$supports[$i]}) {
        next if exists $removed{$support};
        $count++;
      }
      if(!$count) {
        # this brick is unsupported, remove it too
        $removed{refaddr($bricks[$i])} = 1;
        $changed++;
      }
    }
  } while($changed > 0);

  # The number of extra bricks that would fall is the number of bricks in
  # the "removed" hash, less the original.
  $part2 += scalar(keys %removed) - 1;
}

print "Part 2 result: $part2\n";

sub makeBrick {
  if(/([\d,]+)~([\d,]+)/) {
    my $c1 = $1;
    my $c2 = $2;
    my ($x0, $y0, $z0) = split /,/, $c1;
    my ($x1, $y1, $z1) = split /,/, $c2;
    my $dx = $x1 <=> $x0;
    my $dy = $y1 <=> $y0;
    my $dz = $z1 <=> $z0;
    my @r = ( );
    # Add block locations to r all along the line from c1 to c2.
    push @r, [ $x0, $y0, $z0 ];
    do {
      $x0 += $dx; $y0 += $dy; $z0 += $dz;
      push @r, [ $x0, $y0, $z0 ];
    } while ($x0 != $x1 || $y0 != $y1 || $z0 != $z1);
    return \@r;
  } else {
    return undef;
  }
}

sub mapBrick {
  # For each block location, add it to the map.
  for my $c (@{$_[0]}) {
    my $key = join ',', @$c;
    $map{$key} = $_[0];
  }
}

sub unmapBrick {
  for my $c (@{$_[0]}) {
    my $key = join ',', @$c;
    delete $map{$key};
  }
}

sub brickAt {
  return \$FLOOR if($_[2] < 1);
  my $key = join ',', @_;
  return $map{$key};
}

sub supporting {
  my %r = ( );
  for my $c (@{$_[0]}) {
    my $m = brickAt($c->[0], $c->[1], $c->[2] - 1);
    next if $m == $_[0]; # otherwise a vertical brick will
                         # falsely support itself.
    $r{refaddr($m)} = 1 if(defined($m));
  }
  return keys %r;
}

sub dropBrick {
  my $brick = $_[0];
  my @support;
  my $r = 0;

  # Repeatedly move brick z=z-1 until there is something supporting it.
  do {
    @support = supporting($brick);
    if(scalar @support == 0) {
      unmapBrick($brick);
      for my $c (@$brick) {
        $c->[2]--;
      }
      mapBrick($brick);
      $r++;
    }
  } while(scalar @support == 0);

  # Return a count of how far the brick dropped.
  return $r;
}

sub dropAllBricks {
  my $totalDrop; #counter of how far bricks dropped during one pass.
  do {
    $totalDrop = 0;

    for my $brick (@bricks) {
      $totalDrop += dropBrick($brick);
    }
  } while($totalDrop > 0);
}

sub canSafeRemove {
  for my $brick (@bricks) {
    next if $brick == $_[0];
    my @support = supporting($brick);
    return 0 if scalar(@support) == 1 && $support[0] == refaddr($_[0]);
  }
  return 1;
}
