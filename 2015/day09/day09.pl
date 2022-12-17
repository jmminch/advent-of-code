use Data::Dumper;

$shortest = 1 << 32; # ridiculously high
$longest = -1;

while(<>) {
  if(/(\w+) to (\w+) = (\d+)/) {
    # Put both orders in the distance table, so I don't have to worry about
    # ordering of the cities when looking up a pair later.
    $dist{"$1.$2"} = $3;
    $dist{"$2.$1"} = $3;
    $cities{$1} = 1;
    $cities{$2} = 1;
  }
}

sub permute {
  my ($list, $idx) = @_;

  if($idx == $#$list) {
    # last element; calculate the path length for this path.
    my $pathlen = 0;
    for my $i (1..$#$list) {
      $pathlen += $dist{"$list->[$i-1].$list->[$i]"};
    }

    $shortest = $pathlen if $shortest > $pathlen;
    $longest = $pathlen if $pathlen > $longest;

  } else {
    # rotate the last elements of the list, starting at idx, and then call
    # permute on the remaining elements for each rotation until the first
    # element is back in its original place.
    for my $i ($idx..$#$list) {
      # remove the element at $idx and insert at the end to rotate 1 left.
      push @$list, splice(@$list, $idx, 1);

      permute($list, $idx+1);
    }
  }
}

my @path = sort keys %cities;

permute(\@path, 0);

print "part 1 result: $shortest\n";
print "part 2 result: $longest\n";
