use Data::Dumper;

# read the input file.
while(<>) {
  chomp;
  if(/(\w+) => (\w+)/) {
    # this is a replacement rule
    my $atom = $1;
    my $product = $2;

    my $productList = [ ];
    while(length $product) {
      $product =~ s/^([A-Z][a-z]?)//;
      push @$productList, $1;
    }

    push @{$replace{$atom}}, $productList;
  } elsif(/\w/) {
    # this is the molecule to be processed
    $molecule = $_;
  }
}

# split the molecule into atoms.
my @molecule;
while(length $molecule) {
  $molecule =~ s/^([A-Z][a-z]?)//;
  push @molecule, $1;
}

my $atoms = [ 'e' ];

my $steps = createMolecule($atoms, 0, \@molecule, 0);

print "part 2 result: $steps\n";

sub createMolecule {
  my ($atoms, $idx, $target, $depth) = @_;

  my $minSteps = 1 << 32;

  print "$idx $depth\n";

  return -1 if length(@$atoms) > length(@$target);

  # if the correct atom is present, first try just moving to the next atom.
  if($atoms->[$idx] eq $target->[$idx]) {
    return 0 if $idx == $#$target;

    my $r = createMolecule($atoms, $idx + 1, $target, $depth + 1);
    $minSteps = $r if $r >= 0;
    return $r if $r >= 0;
  }

  # for each possible substitution for atoms->[idx], make the substitution
  # and then call createMolecule again.
  for $sub (@{$replace{$atoms->[$idx]}}) {
    my $tmpAtoms = [ @{$atoms} ];
    splice @$tmpAtoms, $idx, 1, @$sub;
    my $r = createMolecule($tmpAtoms, $idx, $target, $depth + 1);
    return ($r + 1) if $r >= 0;
  }

  return -1;
}

