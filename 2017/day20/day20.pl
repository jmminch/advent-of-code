# Read in particle data.
while(<>) {
  if(/p=<(.*)>, v=<(.*)>, a=<(.*)>/) {
    my ($p, $v, $a) = ($1, $2, $3);
    push @particles, {
      p => [ split(/,/, $p) ],
      v => [ split(/,/, $v) ],
      a => [ split(/,/, $a) ] };
  }
}

# Part 1.
# a. determine the minimum magnitude of acceleration vectors.
my $aMin = 999999;
for my $p (@particles) {
  my $aMag = 0;
  for my $v (@{$p->{a}}) { $aMag += abs($v); }
  $aMin = $aMag if $aMag < $aMin;
}

# b. find the largest time t when each component of the velocity is 0.
my $tMax = 0;
for my $p (@particles) {
  for my $c (0..2) {
    next if $p->{a}->[$c] == 0;
    my $t = 1 + abs($p->{v}->[$c] / $p->{a}->[$c]);
    $tMax = $t if $t > $tMax;
  }
}

# c. look for the particle with aMag == aMin which is closest to the
#    origin about when t=tMax.
my $minDist = -1;
my $minPart = 0;
for my $i (0..$#particles) {
  my $p = $particles[$i];
  my $aMag = 0;
  for my $v (@{$p->{a}}) { $aMag += abs($v); }
  next if $aMag > $aMin;

  my $dist = 0;
  for my $c (0..2) {
    $dist += $p->{p}->[$c] +
             $tMax * $p->{v}->[$c] +
             0.5 * $tMax * $tMax * $p->{a}->[$c];
  }

  if($dist < $minDist || $minDist < 0) {
    $minDist = $dist;
    $minPart = $i;
  }
}

print "Part 1 result: $minPart\n";

# Part 2. Simulate for $tMax seconds. Each tick, if there is a collision,
# remove any particles involved.
for my $t (1..$tMax) {

  # update velocity, then position.
  for my $p (@particles) {
    for my $c (0..2) {
      $p->{v}->[$c] += $p->{a}->[$c];
      $p->{p}->[$c] += $p->{v}->[$c];
    }
  }

  # record all positions, looking for collisions. $foundPos{pos} is set for
  # each position, and then $collPos{pos} is set when we find a second one
  # for that position.
  %foundPos = ( );
  %collPos = ( );
  for my $p (@particles) {
    my $pos = join ',', @{$p->{p}};
    if(exists $foundPos{$pos}) {
      $collPos{$pos}++;
    } else {
      $foundPos{$pos}++;
    }
  }

  # remove any particles that collided.
  for(my $i = 0; $i <= $#particles; $i++) {
    my $p = $particles[$i];
    my $pos = join ',', @{$p->{p}};
    if(exists $collPos{$pos}) {
      splice @particles, $i, 1;
      $i--; # to get the particle now in this slot.
      next;
    }
  }
}

# How many particles remain?
printf "Part 2 result: %d\n", scalar @particles;
