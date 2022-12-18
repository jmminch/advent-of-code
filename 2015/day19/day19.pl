use Data::Dumper;

# read the input file.
while(<>) {
  chomp;
  if(/(\w+) => (\w+)/) {
    # this is a replacement rule
    push @{$replace{$1}}, $2;
  } elsif(/\w/) {
    # this is the molecule to be processed
    push @molecule, $_;
  }
}

my @products = getProducts($molecule[0]);

print "part 1 result: ", scalar @products, "\n";

# For part 2, start with 'e', and then each step produce all the possible
# products; try to find the shortest path that produces the target molecule.

my $depth = 0;
my %newopts = ( e=>1 );
my %seen = ( e=>1 );

LOOP: while(1) {
  $depth++;
  @opts = keys %newopts;
  %newopts = ();

  print "$depth: ", scalar @opts, "\n";

  for $opt (@opts) {

    my @products = getProducts($opt);
    for $p (@products) {
      last LOOP if $p eq $molecule[0];
      next if length $p > length $molecule[0]; # no rules result in a shorter len
      $newopts{$p} = 1 if !exists $seen{$p};
      $seen{$p} = 1;
    }

  }
}

print "part 2 result: $depth\n";

sub getProducts {
  # loop through every replaceable atom, and replace it with every possible
  # replacement.
  my $mol = $_[0];
  my %products = ();

  for my $atom (keys %replace) {

    while($mol =~ /$atom/g) {
      for my $out (@{$replace{$atom}}) {
        my $tmp = $mol;
        substr($tmp, $-[0], length($atom), $out);

        # make a hash out of the produced molecules.
        $products{$tmp} = 1;
      }
    }

  }

  return keys %products;
}
