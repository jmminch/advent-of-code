while(<>) {
  push @weights, int($_) if $_ =~ /\d/;
}

@used = ( 0 ) x (scalar @weights);
$minGSize = 999999;
$minProduct = 9e50;

# find all combinations of packages that weigh 1/3 of the total.
my $totWeight = 0;
for my $w (@weights) { $totWeight += $w; }
$thWeight = $totWeight / 3;
$qWeight = $totWeight / 4;

#makeCombo(1, $thWeight, 0, \&handleGroup1);

print "part 1 result: $minProduct\n";

@used = ( 0 ) x (scalar @weights);
$minGSize = 999999;
$minProduct = 9e50;
makeCombo(1, $qWeight, 0, \&pt2_1);
print "part 1 result: $minProduct\n";

sub handleGroup1 {
  # find the size of the found group, skip processing if it's bigger than
  # the smallest group found.
  my $gSize = 0;
  for my $idx (0..$#weights) {
    $gSize++ if $used[$idx] == 1;
  }
  return if $gSize > $minGSize;

  # the used[] array has the group 1 data in it now.
  makeCombo(2, $thWeight, 0, \&handleGroup2);
}

sub handleGroup2 {
  # the used[] array has group 1 and 2 data in it now; so group 3 is
  # anything left marked as 0.

  # count the sizes of the groups
  my @gSize = (0, 0, 0);
  my $product = 1;

  for my $idx (0..$#weights) {
    $gSize[$used[$idx]]++;
    $product *= $weights[$idx] if $used[$idx] == 1;
  }

  my $oldGSize = $minGSize;
  $minGSize = $gSize[0] if $minGSize > $gSize[0];
  $minGSize = $gSize[1] if $minGSize > $gSize[1];
  $minGSize = $gSize[2] if $minGSize > $gSize[2];
  $minProduct = 9e50 if $oldGSize > $minGSize;

  # don't consider if group 1 has too many packages.
  return if $gSize[1] > $minGSize;

  if($minProduct > $product) {
    $minProduct = $product;
  }

  return;
}

sub pt2_1 {
  # find the size of the found group, skip processing if it's bigger than
  # the smallest group found.
  my $gSize = 0;
  for my $idx (0..$#weights) {
    $gSize++ if $used[$idx] == 1;
  }
  return if $gSize > $minGSize;

  # the used[] array has the group 1 data in it now.
  makeCombo(2, $qWeight, 0, \&pt2_2);
}

sub pt2_2 {
  # the used[] array has the group 2 data in it now.
  makeCombo(3, $qWeight, 0, \&pt2_3);
}

sub pt2_3 {
  # the used[] array has group 1 and 2 data in it now; so group 3 is
  # anything left marked as 0.

  # count the sizes of the groups
  my @gSize = (0, 0, 0, 0);
  my $product = 1;

  for my $idx (0..$#weights) {
    $gSize[$used[$idx]]++;
    $product *= $weights[$idx] if $used[$idx] == 1;
  }

  my $oldGSize = $minGSize;
  $minGSize = $gSize[0] if $minGSize > $gSize[0];
  $minGSize = $gSize[1] if $minGSize > $gSize[1];
  $minGSize = $gSize[2] if $minGSize > $gSize[2];
  $minGSize = $gSize[3] if $minGSize > $gSize[3];
  if($oldGSize > $minGSize) {
    $minProduct = 9e50 if $oldGSize > $minGSize;
    print "new min group size: $minGSize\n";
  }

  # don't consider if group 1 has too many packages.
  return if $gSize[1] > $minGSize;

  if($minProduct > $product) {
    $minProduct = $product;
  }

  return;
}

sub makeCombo {
  my ($group, $maxWeight, $startIdx, $callback) = @_;

  for my $idx ($startIdx..$#weights) {
    next if $used[$idx] != 0;
    $used[$idx] = $group;
    $maxWeight -= $weights[$idx];
    if($maxWeight > 0) {
      makeCombo($group, $maxWeight, $idx+1, $callback);
    } elsif($maxWeight == 0) {
      &$callback();
    }
    # otherwise, this weight put it over the limit, just move on.

    $maxWeight += $weights[$idx];
    $used[$idx] = 0;
  }
}
