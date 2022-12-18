use Data::Dumper;
use List::Util qw(min);

# read the input file. For part 2, I am going to work backwards, so create a
# table of product => atom.
while(<>) {
  chomp;
  if(/(\w+) => (\w+)/) {
    # this is a replacement rule
    my $atom = $1;
    my $product = $2;

    push @{$replace{$product}}, $atom;
  } elsif(/\w/) {
    # this is the molecule to be processed
    $molecule = $_;
  }
}

$minLen = 9999999;
my @path = ();
my $result = decompose($molecule, \@path);
print "part 2 result: $result\n";

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

# This sub tries each possible substitution in order, and then calls
# decompose on the result; after trying them all it returns 1 + the minimum
# return value.
#
# If the input is the target, 'e', then return 0.
# If the input contains 'e', then it's invalid. Return a huge number.
#

sub decompose {
  my $molecule = $_[0];
  my $path = $_[1];

  $counter++;
  print "$molecule\n" if(($counter & 0xFFFF) == 0);

  if($molecule eq 'e') {
    print "found path, len = ", scalar @$path, "\n";
    $minLen = scalar @$path if scalar(@$path) < $minLen;
    return 0;
  }
  #return 0 if $molecule eq 'e';
  return 9999999 if index($molecule, 'e') > -1;
  return 9999999 if scalar(@$path) > $minLen;

  return $cache{$molecule} if exists $cache{$molecule};

  # If I don't sort the keys, then the order changes whenever I change the
  # program, which makes comparing the results when I make changes hard.
  my @products = getProducts($molecule);
  @products = sort { length $a <=> $b } @products;

  push @$path, $molecule;

  my $min = min(map { decompose($_, $path) } @products);
  $cache{$molecule} = $min + 1;

  pop @$path;

  return $min + 1;
}
